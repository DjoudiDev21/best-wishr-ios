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
            // Initialize authStore first
            let httpClient = HttpClient(baseURL: URL(string: "https://api.example.com")!)
            let authRepository = HttpAuthRepository(httpClient: httpClient)
            let loginUseCase = LoginUseCase(repository: authRepository)
            let authPresenter = AuthPresenter(loginUseCase: loginUseCase)
            self.authStore = AuthStore(presenter: authPresenter)
            
            observeAuthChanges()
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
