import Foundation

class AuthPresenter: AuthPresenterProtocol {
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    
    init(loginUseCase: LoginUseCase, registerUseCase: RegisterUseCase, forgotPasswordUseCase: ForgotPasswordUseCase) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.forgotPasswordUseCase = forgotPasswordUseCase
    }

    func performLogin(email: String, password: String) async -> Result<User, Error> {
        await loginUseCase.execute(email: email, password: password)
    }
    
    func performRegister(email: String, password: String, firstName: String, lastName: String) async -> Result<User, Error> {
        await registerUseCase.execute(email: email, password: password, firstName: firstName, lastName: lastName)
    }
    
    func performForgotPassword(email: String) async -> Result<Void, Error> {
        await forgotPasswordUseCase.execute(email: email)
    }
}
