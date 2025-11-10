import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
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
