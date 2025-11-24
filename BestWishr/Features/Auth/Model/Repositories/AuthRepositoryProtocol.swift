import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthSession
    func register(email: String, password: String, firstname: String, lastname: String) async throws -> Void
    func verifyEmail(token: String) async throws -> AuthSession
    func resendVerificationEmail(email: String) async throws
    func logout(refreshToken: String) async throws
    func forgotPassword(email: String) async throws
    func appleAuth(request: AppleAuthRequestDto) async throws -> AuthSession
}
