import Foundation
import AuthenticationServices
import Combine

@MainActor
final class AppleAuthService: NSObject, ObservableObject {
    
    // MARK: - Published States
    @Published private(set) var isLoading = false
    
    // MARK: - Private Properties
    private var currentRequest: ASAuthorizationAppleIDRequest?
    private var continuation: CheckedContinuation<AppleAuthResult, Error>?
    
    // MARK: - Types
    struct AppleAuthResult {
        let userIdentifier: String
        let email: String?
        let fullName: PersonNameComponents?
        let identityToken: String
        let authorizationCode: String
    }
    
    // MARK: - Public Methods
    func auth() async throws -> AppleAuthResult {
        print("🍎 AppleAuthService: Starting Apple Sign-In process")
        isLoading = true
        defer { 
            isLoading = false
            print("🍎 AppleAuthService: Finished Apple Sign-In process, loading = false")
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            print("🍎 AppleAuthService: Setting up continuation for async auth")
            self.continuation = continuation
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            print("🍎 AppleAuthService: Created request with scopes: \(request.requestedScopes?.description ?? "none")")
            
            self.currentRequest = request
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            print("🍎 AppleAuthService: About to perform authorization requests")
            authorizationController.performRequests()
            print("🍎 AppleAuthService: Authorization requests performed")
        }
    }
    
    func checkCredentialState(for userID: String) async throws -> ASAuthorizationAppleIDProvider.CredentialState {
        return try await withCheckedThrowingContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) { credentialState, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: credentialState)
                }
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("🍎 AppleAuthService: Authorization completed successfully")
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("🍎 AppleAuthService: ERROR - Invalid credential type")
            continuation?.resume(throwing: AppleAuthError.invalidCredential)
            continuation = nil
            return
        }
        print("🍎 AppleAuthService: Got Apple ID credential for user: \(appleIDCredential.user)")
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            print("🍎 AppleAuthService: ERROR - Missing or invalid identity token")
            continuation?.resume(throwing: AppleAuthError.missingIdentityToken)
            continuation = nil
            return
        }
        print("🍎 AppleAuthService: Got identity token: \(String(identityToken.prefix(50)))...")
        
        guard let authorizationCodeData = appleIDCredential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            print("🍎 AppleAuthService: ERROR - Missing or invalid authorization code")
            continuation?.resume(throwing: AppleAuthError.missingAuthorizationCode)
            continuation = nil
            return
        }
        print("🍎 AppleAuthService: Got authorization code: \(String(authorizationCode.prefix(20)))...")
        
        let result = AppleAuthResult(
            userIdentifier: appleIDCredential.user,
            email: appleIDCredential.email,
            fullName: appleIDCredential.fullName,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
        
        print("🍎 AppleAuthService: Created result with email: \(result.email ?? "nil"), fullName: \(result.fullName?.description ?? "nil")")
        continuation?.resume(returning: result)
        continuation = nil
        print("🍎 AppleAuthService: Resumed continuation with success")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("🍎 AppleAuthService: Authorization completed with ERROR: \(error.localizedDescription)")
        
        if let authError = error as? ASAuthorizationError {
            print("🍎 AppleAuthService: ASAuthorizationError code: \(authError.code.rawValue)")
            switch authError.code {
            case .canceled:
                print("🍎 AppleAuthService: User canceled authorization")
                continuation?.resume(throwing: AppleAuthError.userCanceled)
            case .failed:
                print("🍎 AppleAuthService: Authorization failed")
                continuation?.resume(throwing: AppleAuthError.authorizationFailed)
            case .invalidResponse:
                print("🍎 AppleAuthService: Invalid response")
                continuation?.resume(throwing: AppleAuthError.invalidResponse)
            case .notHandled:
                print("🍎 AppleAuthService: Not handled")
                continuation?.resume(throwing: AppleAuthError.notHandled)
            case .unknown:
                print("🍎 AppleAuthService: Unknown error")
                continuation?.resume(throwing: AppleAuthError.unknown)
            @unknown default:
                print("🍎 AppleAuthService: Unknown default error")
                continuation?.resume(throwing: AppleAuthError.unknown)
            }
        } else {
            print("🍎 AppleAuthService: Non-ASAuthorizationError: \(type(of: error))")
            continuation?.resume(throwing: error)
        }
        continuation = nil
        print("🍎 AppleAuthService: Error handling complete, continuation cleared")
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("Unable to get key window for Apple Sign In presentation")
        }
        return window
    }
}

// MARK: - AppleAuthError
enum AppleAuthError: Error, LocalizedError {
    case invalidCredential
    case missingIdentityToken
    case missingAuthorizationCode
    case userCanceled
    case authorizationFailed
    case invalidResponse
    case notHandled
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid Apple Sign In credential received"
        case .missingIdentityToken:
            return "Identity token missing from Apple Sign In response"
        case .missingAuthorizationCode:
            return "Authorization code missing from Apple Sign In response"
        case .userCanceled:
            return "Apple Sign In was canceled by user"
        case .authorizationFailed:
            return "Apple Sign In authorization failed"
        case .invalidResponse:
            return "Invalid response from Apple Sign In"
        case .notHandled:
            return "Apple Sign In request was not handled"
        case .unknown:
            return "Unknown Apple Sign In error occurred"
        }
    }
}
