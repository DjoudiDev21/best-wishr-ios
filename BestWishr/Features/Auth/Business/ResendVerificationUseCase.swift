import Foundation

struct ResendVerificationUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String) async -> Result<Void, Error> {
        print("📧 ResendVerificationUseCase: execute() called with email: '\(email)'")
        do {
            print("📧 ResendVerificationUseCase: Calling repository.resendVerificationEmail()")
            try await repository.resendVerificationEmail(email: email)
            print("✅ ResendVerificationUseCase: Repository call successful")
            return .success(())
        } catch {
            print("❌ ResendVerificationUseCase: Repository call failed with error: \(error)")
            return .failure(error)
        }
    }
}