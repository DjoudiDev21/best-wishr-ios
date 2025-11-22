import Foundation

class VerifyEmailUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(token: String) async -> Result<AuthSession, Error> {
        do {
            let session = try await repository.verifyEmail(token: token)
            return .success(session)
        } catch {
            return .failure(error)
        }
    }
}