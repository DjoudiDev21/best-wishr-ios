import Foundation

struct AppleAuthUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(request: AppleAuthRequestDto) async -> Result<AuthSession, Error> {
        print("🎪 AppleAuthUseCase: Executing Apple auth with request")
        print("🎪 AppleAuthUseCase: Identity token: \(String(request.identityToken.prefix(50)))...")
        print("🎪 AppleAuthUseCase: Authorization code: \(String(request.authorizationCode.prefix(20)))...")
        
        do {
            print("🎪 AppleAuthUseCase: Calling repository.appleAuth")
            let session = try await repository.appleAuth(request: request)
            print("🎪 AppleAuthUseCase: Repository call SUCCESS - user: \(session.user.email)")
            return .success(session)
        } catch {
            print("🎪 AppleAuthUseCase: Repository call FAILED - error: \(error.localizedDescription)")
            print("🎪 AppleAuthUseCase: Error type: \(type(of: error))")
            return .failure(error)
        }
    }
}
