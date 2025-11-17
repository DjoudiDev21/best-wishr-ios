import Foundation

class VerifyEmailUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(token: String) async -> Result<Void, Error> {
        do {
            try await repository.verifyEmail(token: token)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}