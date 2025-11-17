import Foundation

struct AppleAuthUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(request: AppleAuthRequestDto) async -> Result<User, Error> {
        do {
            let user = try await repository.appleAuth(request: request)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
}
