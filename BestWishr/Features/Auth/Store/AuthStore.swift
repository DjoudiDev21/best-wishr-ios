import Foundation
import Combine

@MainActor
final class AuthStore: ObservableObject {
    // MARK: - Published States
    @Published private(set) var user: User? = nil
    @Published private(set) var isAuthenticated = false
    @Published private(set) var isLoading = false
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
        print("🏪 AuthStore: Starting login flow for email: \(email)")
        isLoading = true
        print("🏪 AuthStore: Loading state set to true")

        let result = await presenter.performLogin(email: email, password: password)

        switch result {
        case .success(let user):
            print("🏪 AuthStore: Login successful, handling success")
            handleLoginSuccess(user)
        case .failure(let loginError):
            print("🏪 AuthStore: Login failed, handling error: \(loginError)")
            handleLoginFailure(loginError)
        }

        isLoading = false
        print("🏪 AuthStore: Loading state set to false")
    }
    
    func register(email: String, password: String, firstname: String, lastname: String) async {
        isLoading = true

        let result = await presenter.performRegister(email: email, password: password, firstname: firstname, lastname: lastname)

        switch result {
        case .success():
            let successMessage = "Account created! Please check your email to verify before logging in."
            notificationHandler.showSuccess(successMessage)
        case .failure(let error):
            handleLoginFailure(error)
        }

        isLoading = false
    }
    
    func verifyEmailAndLogin(token: String, email: String) async -> Bool {
        isLoading = true
        
        // First verify the email
        let verificationResult = await presenter.performEmailVerification(token: token)
        
        switch verificationResult {
        case .success:
            let successMessage = "Email verified successfully! Please log in to continue."
            notificationHandler.showSuccess(successMessage)
            isLoading = false
            return true
        case .failure(let error):
            handleLoginFailure(error)
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
        print("🍎 AuthStore: Starting Apple Sign-In flow")
        isLoading = true
        print("🍎 AuthStore: Loading state set to true")
        
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
        case .success(let user):
            print("🍎 AuthStore: Apple Sign-In successful, handling success")
            handleLoginSuccess(user)
        case .failure(let error):
            print("🍎 AuthStore: Apple Sign-In failed, handling error: \(error)")
            handleLoginFailure(error)
        }
        
        isLoading = false
        print("🍎 AuthStore: Loading state set to false")
    }
    
    func logout() {
        user = nil
        isAuthenticated = false
    }
        
    // MARK: - Private Helpers
    private func handleLoginSuccess(_ user: User) {
        print("🏪 AuthStore: Setting user and authenticated state - User ID: \(user.id)")
        self.user = user
        self.isAuthenticated = true
        print("🏪 AuthStore: Auth state updated - isAuthenticated: \(isAuthenticated)")
    }

    private func handleLoginFailure(_ error: Error) {
        print("🏪 AuthStore: Handling login failure: \(error)")
        errorHandler.handle(error)
        self.isAuthenticated = false
        print("🏪 AuthStore: Auth state updated - isAuthenticated: \(isAuthenticated)")
    }
}
