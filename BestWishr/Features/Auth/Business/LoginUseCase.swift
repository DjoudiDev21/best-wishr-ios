import Foundation

struct LoginUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
         self.repository = repository
     }

    func execute(email: String, password: String) async -> Result<User, Error> {
        do {
            let user = try await repository.login(email: email, password: password)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
}
