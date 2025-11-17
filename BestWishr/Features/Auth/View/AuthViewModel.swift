import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    // Form state only
    @Published var email = "abdelkrim.djoudi.dev@gmail.com"
    @Published var password = "Gstarraw95100?"
    @Published var firstname = "A"
    @Published var lastname = "B"
    @Published var confirmPassword = "Gstarraw95100?"
    @Published var agreeToTerms = true
    @Published var isButtonDisabled = true
    
    private let store: AuthStore

    init(store: AuthStore) {
        self.store = store
        setupBindings()
    }
    
    private func setupBindings() {
        // Form validation only
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
    
    func register() {
//        guard email.isValidEmail else {
//            errorMessage = "Email invalide"
//            return
//        }

        Task {
            await store.register(email: email, password: password, firstname: firstname, lastname: lastname)
        }
    }
}
