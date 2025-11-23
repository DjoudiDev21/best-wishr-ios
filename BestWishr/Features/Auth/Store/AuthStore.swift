import Foundation
import Combine

@MainActor
final class AuthStore: ObservableObject {
    // MARK: - Published States
    @Published private(set) var user: User? = nil
    @Published private(set) var tokens: AuthTokens? = nil
    @Published private(set) var isLoading = false
    @Published private(set) var isResendingVerification = false
    @Published private(set) var lastLoginFailedDueToUnverifiedEmail = false
    @Published private(set) var emailForVerificationResend: String = ""
    
    // MARK: - Computed Properties  
    @Published private(set) var isAuthenticated: Bool = false
    
    var currentSession: AuthSession? {
        guard let user = user, let tokens = tokens else { return nil }
        return AuthSession(user: user, tokens: tokens)
    }
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies
    private let presenter: AuthPresenterProtocol
    private let errorHandler: GlobalErrorHandlerProtocol
    private let notificationHandler: GlobalNotificationHandlerProtocol
    
    // MARK: - Init
     init(presenter: AuthPresenterProtocol, errorHandler: GlobalErrorHandlerProtocol? = nil, notificationHandler: GlobalNotificationHandlerProtocol? = nil) {
         self.presenter = presenter
         self.errorHandler = errorHandler ?? GlobalErrorHandler.shared
         self.notificationHandler = notificationHandler ?? GlobalNotificationHandler.shared
     }
    
    // MARK: - Actions
    func login(email: String, password: String) async {
        isLoading = true

        let result = await presenter.performLogin(email: email, password: password)

        switch result {
        case .success(let session):
            handleLoginSuccess(session)
        case .failure(let loginError):
            handleLoginFailure(loginError, email: email)
        }

        isLoading = false
    }
    
    func register(email: String, password: String, firstname: String, lastname: String) async {
        isLoading = true

        let result = await presenter.performRegister(email: email, password: password, firstname: firstname, lastname: lastname)

        switch result {
        case .success():
            let successMessage = "Account created! Please check your email to verify before logging in."
            notificationHandler.showSuccess(successMessage)
        case .failure(let error):
            handleLoginFailure(error, email: email)
        }

        isLoading = false
    }
    
    func verifyEmailAndLogin(token: String, email: String) async -> Bool {
        isLoading = true
        
        // Store email for potential verification banner
        emailForVerificationResend = email
        
        // Verify email and get user data with auth token
        let verificationResult = await presenter.performEmailVerification(token: token)
        
        switch verificationResult {
        case .success(let session):
            // Auto-login the user with the returned auth token
            let successMessage = "Email verified successfully! Welcome to BestWishr!"
            notificationHandler.showSuccess(successMessage)
            handleLoginSuccess(session)
            isLoading = false
            return true
        case .failure(let error):
            handleVerificationFailure(error)
            isLoading = false
            return false
        }
    }
    
    func forgotPassword(email: String) async {
        isLoading = true

        let result = await presenter.performForgotPassword(email: email)

        switch result {
        case .success:
            break
        case .failure(let error):
            errorHandler.handle(error)
        }

        isLoading = false
    }
    
    func appleAuth(identityToken: String, authorizationCode: String) async {
        isLoading = true
        
        let request = AppleAuthRequestDto(
            userIdentifier: "", // We'll get this from the backend response
            email: nil, // Backend will extract from token
            firstName: nil,
            lastName: nil,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
        
        let result = await presenter.performAppleAuth(request: request)
        
        switch result {
        case .success(let session):
            handleLoginSuccess(session)
        case .failure(let error):
            handleLoginFailure(error, email: nil)
        }
        
        isLoading = false
    }
    
    func resendVerificationEmail(email: String) async {
        isResendingVerification = true
        
        let result = await presenter.performResendVerificationEmail(email: email)
        
        switch result {
        case .success:
            print("✅ AuthStore: Resend successful")
            // Success feedback is now handled by the header banner UI
        case .failure(let error):
            errorHandler.handle(error)
        }
        
        isResendingVerification = false
    }
    
    func logout() {
        user = nil
        tokens = nil
        updateAuthState()
    }
    
    // MARK: - Private Helpers
    private func handleLoginSuccess(_ session: AuthSession) {
        self.user = session.user
        self.tokens = session.tokens
        self.lastLoginFailedDueToUnverifiedEmail = false
        self.emailForVerificationResend = ""
        updateAuthState()
    }

    private func handleLoginFailure(_ error: Error, email: String?) {
        // Check if error is specifically due to unverified email
        let isUnverifiedEmailError = isUnverifiedEmailError(error)
        lastLoginFailedDueToUnverifiedEmail = isUnverifiedEmailError
        
        if isUnverifiedEmailError {
            // Store email for verification banner
            if let email = email {
                emailForVerificationResend = email
            }
        } else {
            // For other login errors (wrong password, network issues, etc.), show regular error alert
            errorHandler.handle(error)
        }
        
        self.user = nil
        self.tokens = nil
        updateAuthState()
    }
    
    private func isUnverifiedEmailError(_ error: Error) -> Bool {
        if let appError = error as? AppError {
            switch appError {
            case .authentication(let message):
                let lowercased = message.lowercased()
                return lowercased.contains("verify") || 
                       lowercased.contains("unverified") || 
                       lowercased.contains("verification") ||
                       lowercased.contains("email not verified")
            case .server(let code, let message):
                if code == 403 {
                    let lowercased = message.lowercased()
                    return lowercased.contains("verify") || 
                           lowercased.contains("unverified") || 
                           lowercased.contains("verification")
                }
                return false
            default:
                return false
            }
        }
        return false
    }
    
    private func handleVerificationFailure(_ error: Error) {
        // Check for specific error types and determine if we should show verification banner
        let errorMessage: String
        var shouldShowVerificationBanner = false
        
        if let appError = error as? AppError {
            switch appError {
            case .authentication(let message) where message.contains("expired") || message.contains("invalid"):
                errorMessage = "This verification link has expired. Please request a new one."
                shouldShowVerificationBanner = true
            case .authentication(let message):
                errorMessage = message
                shouldShowVerificationBanner = true
            case .validation(let message) where message.lowercased().contains("expired") || message.lowercased().contains("invalid") || message.lowercased().contains("verification"):
                errorMessage = "This verification link has expired. Please request a new one."
                shouldShowVerificationBanner = true
            case .server(let code, _) where code == 400:
                errorMessage = "This verification link is invalid or has expired. Please request a new one."
                shouldShowVerificationBanner = true
            case .server(_, let message):
                errorMessage = "Server error: \(message)"
            case .network(let message):
                errorMessage = "Network error: \(message)"
            case .validation(let message):
                errorMessage = message
            default:
                errorMessage = "Verification failed. Please try again."
            }
        } else {
            // Check if it's a JWT expiration error
            let errorString = error.localizedDescription.lowercased()
            if errorString.contains("expired") || errorString.contains("invalid") {
                errorMessage = "This verification link has expired. Please request a new one."
                shouldShowVerificationBanner = true
            } else {
                errorMessage = "Verification failed. Please try again."
            }
        }
        
        // Show verification banner for expired/invalid tokens
        if shouldShowVerificationBanner {
            print("📧 AuthStore: Setting up verification banner with emailForVerificationResend: '\(emailForVerificationResend)'")
            lastLoginFailedDueToUnverifiedEmail = true
            // Use banner presentation mode for verification errors
            errorHandler.handle(
                AppError.validation(errorMessage), 
                presentationMode: .banner, 
                context: ["email": emailForVerificationResend]
            )
        } else {
            // Use alert for non-verification errors (network, server, etc.)
            errorHandler.handle(AppError.validation(errorMessage))
        }
        
        self.user = nil
        self.tokens = nil
        updateAuthState()
    }
    
    private func updateAuthState() {
        let hasValidSession = user != nil && tokens != nil && !(tokens?.isExpired ?? true)
        isAuthenticated = hasValidSession
    }
}
