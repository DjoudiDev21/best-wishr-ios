import Foundation

struct RegisterUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
         self.repository = repository
     }

    func execute(email: String, password: String, firstName: String, lastName: String) async -> Result<User, Error> {
        do {
            let user = try await repository.register(email: email, password: password, firstName: firstName, lastName: lastName)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
}