import Foundation

class AuthPresenter: AuthPresenterProtocol {
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func performLogin(email: String, password: String) async -> Result<User, Error> {
        await loginUseCase.execute(email: email, password: password)
    }
}
