import Foundation

class AuthPresenter: AuthPresenterProtocol {
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let verifyEmailUseCase: VerifyEmailUseCase
    private let resendVerificationUseCase: ResendVerificationUseCase
    private let logoutUseCase: LogoutUseCase
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    private let resetPasswordUseCase: ResetPasswordUseCase
    private let appleAuthUseCase: AppleAuthUseCase
    
    init(loginUseCase: LoginUseCase, registerUseCase: RegisterUseCase, verifyEmailUseCase: VerifyEmailUseCase, resendVerificationUseCase: ResendVerificationUseCase, logoutUseCase: LogoutUseCase, forgotPasswordUseCase: ForgotPasswordUseCase, resetPasswordUseCase: ResetPasswordUseCase, appleAuthUseCase: AppleAuthUseCase) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.verifyEmailUseCase = verifyEmailUseCase
        self.resendVerificationUseCase = resendVerificationUseCase
        self.logoutUseCase = logoutUseCase
        self.forgotPasswordUseCase = forgotPasswordUseCase
        self.resetPasswordUseCase = resetPasswordUseCase
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
        let result = await resendVerificationUseCase.execute(email: email)
        return result
    }
    
    func performLogout(refreshToken: String) async -> Result<Void, Error> {
        let result = await logoutUseCase.execute(refreshToken: refreshToken)
        return result
    }
    
    func performForgotPassword(email: String) async -> Result<Void, Error> {
        await forgotPasswordUseCase.execute(email: email)
    }
    
    func performResetPassword(token: String, newPassword: String) async -> Result<Void, Error> {
        await resetPasswordUseCase.execute(token: token, newPassword: newPassword)
    }
    
    func performAppleAuth(request: AppleAuthRequestDto) async -> Result<AuthSession, Error> {
        print("🎭 AuthPresenter: Starting performAppleAuth")
        print("🎭 AuthPresenter: Identity token: \(String(request.identityToken.prefix(50)))...")
        print("🎭 AuthPresenter: Authorization code: \(String(request.authorizationCode.prefix(20)))...")
        
        let result = await appleAuthUseCase.execute(request: request)
        
        switch result {
        case .success(let session):
            print("🎭 AuthPresenter: AppleAuthUseCase SUCCESS - user: \(session.user.email)")
        case .failure(let error):
            print("🎭 AuthPresenter: AppleAuthUseCase FAILURE - error: \(error.localizedDescription)")
        }
        
        return result
    }
}
