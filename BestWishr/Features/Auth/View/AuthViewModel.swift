import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var email = "user@example.com"  // Default for easy testing
    @Published var password = "password123"    // Default for easy testing
    @Published var isButtonDisabled = true
    
    private let store: AuthStore

    init(store: AuthStore) {
        self.store = store
        setupBindings()
    }
    
    private func setupBindings() {
         // Exemple : validation simple
         $email.combineLatest($password)
             .map { $0.isEmpty || $1.isEmpty }
             .assign(to: &$isButtonDisabled)
     }
    
    func login() {
//        guard email.isValidEmail else {
//            errorMessage = "Email invalide"
//            return
//        }

        Task {
            await store.login(email: email, password: password)
        }
    }
}
