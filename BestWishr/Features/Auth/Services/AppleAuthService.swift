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
        isLoading = true
        defer { isLoading = false }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            self.currentRequest = request
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
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
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleAuthError.invalidCredential)
            continuation = nil
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleAuthError.missingIdentityToken)
            continuation = nil
            return
        }
        
        guard let authorizationCodeData = appleIDCredential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleAuthError.missingAuthorizationCode)
            continuation = nil
            return
        }
        
        let result = AppleAuthResult(
            userIdentifier: appleIDCredential.user,
            email: appleIDCredential.email,
            fullName: appleIDCredential.fullName,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
        
        continuation?.resume(returning: result)
        continuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("🍎 Apple Auth Error: \(error)")
        
        if let authError = error as? ASAuthorizationError {
            print("🍎 ASAuthorizationError Code: \(authError.code.rawValue)")
            print("🍎 ASAuthorizationError Description: \(authError.localizedDescription)")
            
            switch authError.code {
            case .canceled:
                continuation?.resume(throwing: AppleAuthError.userCanceled)
            case .failed:
                continuation?.resume(throwing: AppleAuthError.authorizationFailed)
            case .invalidResponse:
                continuation?.resume(throwing: AppleAuthError.invalidResponse)
            case .notHandled:
                continuation?.resume(throwing: AppleAuthError.notHandled)
            case .unknown:
                continuation?.resume(throwing: AppleAuthError.unknown)
            @unknown default:
                continuation?.resume(throwing: AppleAuthError.unknown)
            }
        } else {
            continuation?.resume(throwing: error)
        }
        continuation = nil
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