import Foundation
@testable import BestWishr

class MockAuthRepository: AuthRepositoryProtocol {
    var loginResult: Result<User, Error>!

    func login(email: String, password: String) async throws -> User {
        switch loginResult! {
        case .success(let user):
            return user
        case .failure(let error):
            throw error
        }
    }
}
