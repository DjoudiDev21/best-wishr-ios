import Foundation

struct LogoutUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
         self.repository = repository
     }

    func execute(refreshToken: String) async -> Result<Void, Error> {
        do {
            try await repository.logout(refreshToken: refreshToken)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}