import Foundation
import Combine

@MainActor
final class AuthStore: ObservableObject {
    // MARK: - Published States
    @Published private(set) var user: User? = nil
    @Published private(set) var tokens: AuthTokens? = nil
    @Published private(set) var isLoading = false
    @Published private(set) var isResendingVerification = false
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
    
    func forgotPassword(email: String, showToast: Bool = true) async {
        isLoading = true

        let result = await presenter.performForgotPassword(email: email)

        switch result {
        case .success:
            if showToast {
                notificationHandler.showSuccess("Password reset instructions have been sent to your email")
            }
        case .failure(let error):
            errorHandler.handle(error)
        }

        isLoading = false
    }
    
    func resetPassword(token: String, newPassword: String, email: String? = nil) async {
        isLoading = true

        let result = await presenter.performResetPassword(token: token, newPassword: newPassword)

        switch result {
        case .success:
            notificationHandler.showSuccess("Password has been reset successfully")
        case .failure(let error):
            handleResetPasswordError(error, email: email)
        }

        isLoading = false
    }
    
    private func handleResetPasswordError(_ error: Error, email: String? = nil) {
        // Check if this is a token-related error that should show banner
        if isResetPasswordTokenError(error) {
            let email = email ?? ""
            errorHandler.handle(
                AppError.validation("Your reset password link has expired. Please request a new one."),
                presentationMode: .banner,
                context: ["email": email, "errorType": BannerErrorType.forgotPassword]
            )
        } else {
            // For other errors (network, validation, etc.), use regular alert
            errorHandler.handle(error)
        }
    }
    
    private func isResetPasswordTokenError(_ error: Error) -> Bool {
        if let appError = error as? AppError {
            switch appError {
            case .validation(let message):
                let lowercased = message.lowercased()
                return lowercased.contains("invalid") && lowercased.contains("token") ||
                       lowercased.contains("expired") && lowercased.contains("token") ||
                       lowercased.contains("reset token")
            default:
                return false
            }
        }
        return false
    }
    
    func appleAuth(identityToken: String, authorizationCode: String) async {
        print("🏪 AuthStore: Starting Apple auth with tokens")
        print("🏪 AuthStore: Identity token: \(String(identityToken.prefix(50)))...")
        print("🏪 AuthStore: Authorization code: \(String(authorizationCode.prefix(20)))...")
        
        isLoading = true
        
        let request = AppleAuthRequestDto(
            userIdentifier: "", // We'll get this from the backend response
            email: nil, // Backend will extract from token
            firstName: nil,
            lastName: nil,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
        
        print("🏪 AuthStore: Created AppleAuthRequestDto, calling presenter.performAppleAuth")
        let result = await presenter.performAppleAuth(request: request)
        
        switch result {
        case .success(let session):
            print("🏪 AuthStore: Apple auth SUCCESS - user: \(session.user.email)")
            handleLoginSuccess(session)
        case .failure(let error):
            print("🏪 AuthStore: Apple auth FAILURE - error: \(error.localizedDescription)")
            handleAppleAuthFailure(error)
        }
        
        isLoading = false
        print("🏪 AuthStore: Apple auth completed, isLoading = false")
    }
    
    func handleAppleAuthError(_ error: Error) async {
        print("🏪 AuthStore: Handling Apple auth error from view model: \(error)")
        handleAppleAuthFailure(error)
    }
    
    func resendVerificationEmail(email: String) async {
        isResendingVerification = true
        
        let result = await presenter.performResendVerificationEmail(email: email)
        
        switch result {
        case .failure(let error):
            errorHandler.handle(error)
        case .success():
            print("toto")
        }
        
        isResendingVerification = false
    }
    
    func logout() async {
        // Get refresh token before clearing state
        let refreshToken = tokens?.refreshToken ?? ""

        // Clear local authentication state immediately for better UX
        user = nil
        tokens = nil
        emailForVerificationResend = ""
        updateAuthState()

        // Perform backend logout in background without showing loading state
        // Only make the call if we have a refresh token
        if !refreshToken.isEmpty {
            Task {
                // Fire and forget - user is already logged out locally
                // Backend call success/failure doesn't affect user experience
                await presenter.performLogout(refreshToken: refreshToken)
            }
        }
    }
    
    // MARK: - Private Helpers
    private func handleLoginSuccess(_ session: AuthSession) {
        self.user = session.user
        self.tokens = session.tokens
        self.emailForVerificationResend = ""
        updateAuthState()
    }

    private func handleLoginFailure(_ error: Error, email: String?) {
        // Check if error is specifically due to unverified email
        let isUnverifiedEmailError = isUnverifiedEmailError(error)
        
        if isUnverifiedEmailError {
            // Store email for verification banner
            if let email = email {
                emailForVerificationResend = email
            }
            // Handle login verification banner directly
            errorHandler.handle(
                AppError.authentication("Email verification required"),
                presentationMode: .banner,
                context: ["email": emailForVerificationResend, "errorType": BannerErrorType.loginUnverified]
            )
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
        
        if shouldShowVerificationBanner {
            errorHandler.handle(
                AppError.validation(errorMessage),
                presentationMode: .banner,
                context: ["email": emailForVerificationResend, "errorType": BannerErrorType.verificationExpired]
            )
        } else {
            // Use alert for non-verification errors (network, server, etc.)
            errorHandler.handle(AppError.validation(errorMessage))
        }
        
        self.user = nil
        self.tokens = nil
        updateAuthState()
    }
    
    private func handleAppleAuthFailure(_ error: Error) {
        // Clear any auth state
        self.user = nil
        self.tokens = nil
        updateAuthState()
        
        // Handle Apple-specific errors with user-friendly messages
        let errorMessage = getAppleAuthErrorMessage(error)
        notificationHandler.showError(errorMessage)
    }
    
    private func getAppleAuthErrorMessage(_ error: Error) -> String {
        // Check if it's an AppleAuthError first
        if let appleAuthError = error as? AppleAuthError {
            switch appleAuthError {
            case .userCanceled:
                return "Apple Sign In was canceled"
            case .authorizationFailed:
                return "Apple Sign In failed. Please try again."
            case .invalidCredential:
                return "Invalid Apple Sign In credentials"
            case .missingIdentityToken, .missingAuthorizationCode:
                return "Apple Sign In setup error. Please try again."
            case .invalidResponse, .notHandled, .unknown:
                return "Apple Sign In is not properly configured. Please enable it in Settings."
            }
        }
        
        // Check if it's a backend error
        if let appError = error as? AppError {
            switch appError {
            case .authentication(let message):
                return "Authentication failed: \(message)"
            case .server(_, let message):
                return "Server error: \(message)"
            case .network(let message):
                return "Network error: \(message)"
            case .validation(let message):
                return message
            default:
                return "Apple Sign In failed. Please try again."
            }
        }
        
        return "Apple Sign In failed: \(error.localizedDescription)"
    }
    
    func handleExpiredVerificationToken(email: String) {
        // Store email for banner
        emailForVerificationResend = email
        
        // Reuse existing verification failure logic with expired token error
        let expiredTokenError = AppError.validation("Invalid or expired verification token")
        handleVerificationFailure(expiredTokenError)
    }
    
    private func updateAuthState() {
        let hasValidSession = user != nil && tokens != nil && !(tokens?.isExpired ?? true)
        isAuthenticated = hasValidSession
    }
}
