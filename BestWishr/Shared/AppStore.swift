import Foundation
import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published var authStore: AuthStore
    private var cancellables = Set<AnyCancellable>()

    var isAuthenticated: Bool {
            authStore.isAuthenticated
        }

        init() {
            // Initialize authStore with environment-based repository
            let authRepository = Self.createAuthRepository()
            let loginUseCase = LoginUseCase(repository: authRepository)
            let registerUseCase = RegisterUseCase(repository: authRepository)
            let forgotPasswordUseCase = ForgotPasswordUseCase(repository: authRepository)
            let authPresenter = AuthPresenter(
                loginUseCase: loginUseCase, 
                registerUseCase: registerUseCase,
                forgotPasswordUseCase: forgotPasswordUseCase
            )
            self.authStore = AuthStore(presenter: authPresenter)
            
            observeAuthChanges()
        }
        
        private static func createAuthRepository() -> AuthRepositoryProtocol {
            #if DEBUG
            // Use mock repository in debug/development
            return MockAuthRepository()
            #else
            // Use real HTTP repository in production
            let httpClient = HttpClient(baseURL: URL(string: "https://api.example.com")!)
            return HttpAuthRepository(httpClient: httpClient)
            #endif
        }

        private func observeAuthChanges() {
            authStore.$isAuthenticated
                .dropFirst()
                .sink { authenticated in
                    if !authenticated {
                        // Exemple : reset d'autres stores
                        // self?.contactsStore.reset()
                    }
                }
                .store(in: &cancellables)
        }
}
