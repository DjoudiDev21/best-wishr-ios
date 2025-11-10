import Foundation

struct ForgotPasswordUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
         self.repository = repository
     }

    func execute(email: String) async -> Result<Void, Error> {
        do {
            try await repository.forgotPassword(email: email)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}