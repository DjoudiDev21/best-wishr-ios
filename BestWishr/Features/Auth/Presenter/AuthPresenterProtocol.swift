import Foundation

protocol AuthPresenterProtocol {
     func performLogin(email: String, password: String) async -> Result<AuthSession, Error>
     func performRegister(email: String, password: String, firstname: String, lastname: String) async -> Result<Void, Error>
     func performEmailVerification(token: String) async -> Result<AuthSession, Error>
     func performResendVerificationEmail(email: String) async -> Result<Void, Error>
     func performLogout(refreshToken: String) async -> Result<Void, Error>
     func performForgotPassword(email: String) async -> Result<Void, Error>
     func performAppleAuth(request: AppleAuthRequestDto) async -> Result<AuthSession, Error>
 }
