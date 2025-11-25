import Foundation

struct ResetPasswordUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
         self.repository = repository
     }

    func execute(token: String, newPassword: String) async -> Result<Void, Error> {
        do {
            try await repository.resetPassword(token: token, newPassword: newPassword)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}