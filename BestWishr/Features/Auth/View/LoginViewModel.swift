import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isButtonDisabled = true
    
    private let store: AuthStore
    private var cancellables = Set<AnyCancellable>()

    init(store: AuthStore) {
        self.store = store
        setupBindings()
    }
    
    private func setupBindings() {
        $email.combineLatest($password)
            .map { email, password in
                email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                password.isEmpty
            }
            .assign(to: \.isButtonDisabled, on: self)
            .store(in: &cancellables)
    }
    
    func login() {
        Task {
            await store.login(email: email, password: password)
        }
    }
}