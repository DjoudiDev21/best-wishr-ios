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
    
    // MARK: - Init
     init(presenter: AuthPresenterProtocol, errorHandler: GlobalErrorHandlerProtocol? = nil) {
         self.presenter = presenter
         self.errorHandler = errorHandler ?? GlobalErrorHandler.shared
     }
    
    // MARK: - Actions
    func login(email: String, password: String) async {
        isLoading = true

        let result = await presenter.performLogin(email: email, password: password)

        switch result {
        case .success(let user):
            handleLoginSuccess(user)
        case .failure(let loginError):
            handleLoginFailure(loginError)
        }

        isLoading = false
    }
    
    func register(email: String, password: String, firstName: String, lastName: String) async {
        isLoading = true

        let result = await presenter.performRegister(email: email, password: password, firstName: firstName, lastName: lastName)

        switch result {
        case .success(let user):
            handleLoginSuccess(user) // Registration also logs the user in
        case .failure(let error):
            handleLoginFailure(error)
        }

        isLoading = false
    }
    
    func forgotPassword(email: String) async {
        isLoading = true

        let result = await presenter.performForgotPassword(email: email)

        switch result {
        case .success:
            // Handle forgot password success (could show a success message)
            break
        case .failure(let error):
            errorHandler.handle(error)
        }

        isLoading = false
    }
    
    func logout() {
        user = nil
        isAuthenticated = false
    }
    
    // MARK: - Private Helpers
    private func handleLoginSuccess(_ user: User) {
        self.user = user
        self.isAuthenticated = true
    }

    private func handleLoginFailure(_ error: Error) {
        errorHandler.handle(error)
        self.isAuthenticated = false
    }
}
