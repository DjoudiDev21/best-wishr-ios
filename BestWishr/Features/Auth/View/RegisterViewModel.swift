import Foundation
import Combine

final class RegisterViewModel: ObservableObject {
    @Published var email = "abdelkrim.djoudi.dev@gmail.com"
    @Published var password = "Gstarraw95100?"
    @Published var firstname = "A"
    @Published var lastname = "B"
    @Published var confirmPassword = "Gstarraw95100?"
    @Published var agreeToTerms = true
    @Published var isButtonDisabled = true
    
    private let store: AuthStore
    private var cancellables = Set<AnyCancellable>()

    init(store: AuthStore) {
        self.store = store
        setupBindings()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest4($email, $password, $confirmPassword, $agreeToTerms)
            .combineLatest($firstname, $lastname)
            .map { (emailPasswordTerms, firstname, lastname) in
                let (email, password, confirmPassword, agreeToTerms) = emailPasswordTerms
                
                return email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                       password.isEmpty ||
                       confirmPassword.isEmpty ||
                       firstname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                       lastname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                       password != confirmPassword ||
                       !agreeToTerms
            }
            .assign(to: \.isButtonDisabled, on: self)
            .store(in: &cancellables)
    }
    
    func register() {
        Task {
            await store.register(email: email, password: password, firstname: firstname, lastname: lastname)
        }
    }
}
