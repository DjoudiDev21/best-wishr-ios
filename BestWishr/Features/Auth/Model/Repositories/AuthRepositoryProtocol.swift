import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
    func register(email: String, password: String, firstname: String, lastname: String) async throws -> Void
    func verifyEmail(token: String) async throws -> Void
    func forgotPassword(email: String) async throws
    func appleAuth(request: AppleAuthRequestDto) async throws -> User
}
