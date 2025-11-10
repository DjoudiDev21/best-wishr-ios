import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
    func register(email: String, password: String, firstName: String, lastName: String) async throws -> User
    func forgotPassword(email: String) async throws
}
