import Foundation

struct RegisterUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
         self.repository = repository
     }

    func execute(email: String, password: String, firstname: String, lastname: String) async -> Result<Void, Error> {
        do {
            try await repository.register(email: email, password: password, firstname: firstname, lastname: lastname)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
