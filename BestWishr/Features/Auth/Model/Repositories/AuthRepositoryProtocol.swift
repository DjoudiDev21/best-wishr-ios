import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
}
