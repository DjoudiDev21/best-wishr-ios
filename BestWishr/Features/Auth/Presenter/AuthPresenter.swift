import Foundation

class AuthPresenter: AuthPresenterProtocol {
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let verifyEmailUseCase: VerifyEmailUseCase
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    
    init(loginUseCase: LoginUseCase, registerUseCase: RegisterUseCase, verifyEmailUseCase: VerifyEmailUseCase, forgotPasswordUseCase: ForgotPasswordUseCase) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.verifyEmailUseCase = verifyEmailUseCase
        self.forgotPasswordUseCase = forgotPasswordUseCase
    }

    func performLogin(email: String, password: String) async -> Result<User, Error> {
        await loginUseCase.execute(email: email, password: password)
    }
    
    func performRegister(email: String, password: String, firstname: String, lastname: String) async -> Result<Void, Error> {
        await registerUseCase.execute(email: email, password: password, firstname: firstname, lastname: lastname)
    }
    
    func performEmailVerification(token: String) async -> Result<Void, Error> {
        await verifyEmailUseCase.execute(token: token)
    }
    
    func performForgotPassword(email: String) async -> Result<Void, Error> {
        await forgotPasswordUseCase.execute(email: email)
    }
}
