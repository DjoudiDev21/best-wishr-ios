import Foundation

struct AppleAuthUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(request: AppleAuthRequestDto) async -> Result<AuthSession, Error> {
        do {
            let session = try await repository.appleAuth(request: request)
            return .success(session)
        } catch {
            return .failure(error)
        }
    }
}
