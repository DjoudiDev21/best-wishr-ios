import Foundation

struct LoginUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
         self.repository = repository
     }

    func execute(email: String, password: String) async -> Result<AuthSession, Error> {
        do {
            let session = try await repository.login(email: email, password: password)
            return .success(session)
        } catch {
            return .failure(error)
        }
    }
}
