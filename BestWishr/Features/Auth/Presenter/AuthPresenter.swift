import Foundation

class AuthPresenter: AuthPresenterProtocol {
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let verifyEmailUseCase: VerifyEmailUseCase
    private let resendVerificationUseCase: ResendVerificationUseCase
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    private let appleAuthUseCase: AppleAuthUseCase
    
    init(loginUseCase: LoginUseCase, registerUseCase: RegisterUseCase, verifyEmailUseCase: VerifyEmailUseCase, resendVerificationUseCase: ResendVerificationUseCase, forgotPasswordUseCase: ForgotPasswordUseCase, appleAuthUseCase: AppleAuthUseCase) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.verifyEmailUseCase = verifyEmailUseCase
        self.resendVerificationUseCase = resendVerificationUseCase
        self.forgotPasswordUseCase = forgotPasswordUseCase
        self.appleAuthUseCase = appleAuthUseCase
    }

    func performLogin(email: String, password: String) async -> Result<AuthSession, Error> {
        await loginUseCase.execute(email: email, password: password)
    }
    
    func performRegister(email: String, password: String, firstname: String, lastname: String) async -> Result<Void, Error> {
        await registerUseCase.execute(email: email, password: password, firstname: firstname, lastname: lastname)
    }
    
    func performEmailVerification(token: String) async -> Result<AuthSession, Error> {
        await verifyEmailUseCase.execute(token: token)
    }
    
    func performResendVerificationEmail(email: String) async -> Result<Void, Error> {
        print("📧 AuthPresenter: performResendVerificationEmail() called with email: '\(email)'")
        let result = await resendVerificationUseCase.execute(email: email)
        print("📧 AuthPresenter: resendVerificationUseCase.execute() returned: \(result)")
        return result
    }
    
    func performForgotPassword(email: String) async -> Result<Void, Error> {
        await forgotPasswordUseCase.execute(email: email)
    }
    
    func performAppleAuth(request: AppleAuthRequestDto) async -> Result<AuthSession, Error> {
        await appleAuthUseCase.execute(request: request)
    }
}
