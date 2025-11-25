import Foundation
import Combine

final class ResetPasswordViewModel: ObservableObject {
    @Published var newPassword = "Gstarrwa95100??"
    @Published var confirmPassword = "Gstarrwa95100??"
    @Published var isButtonDisabled = true
    @Published var showPasswordMismatchError = false
    @Published var showPasswordLengthError = false
    @Published var shouldDismiss = false

    private let store: AuthStore
    private let token: String
    private let email: String
    private var cancellables = Set<AnyCancellable>()
    
    init(store: AuthStore, token: String, email: String = "") {
        self.store = store
        self.token = token
        self.email = email
        setupBindings()
    }
    
    private func setupBindings() {
        // Button disabled state
        Publishers.CombineLatest($newPassword, $confirmPassword)
            .map { newPassword, confirmPassword in
                return newPassword.isEmpty || 
                       confirmPassword.isEmpty || 
                       newPassword != confirmPassword || 
                       newPassword.count < 6
            }
            .assign(to: \.isButtonDisabled, on: self)
            .store(in: &cancellables)
        
        // Password mismatch error
        Publishers.CombineLatest($newPassword, $confirmPassword)
            .map { newPassword, confirmPassword in
                return !newPassword.isEmpty && !confirmPassword.isEmpty && newPassword != confirmPassword
            }
            .assign(to: \.showPasswordMismatchError, on: self)
            .store(in: &cancellables)
        
        // Password length error
        $newPassword
            .map { newPassword in
                return !newPassword.isEmpty && newPassword.count < 6
            }
            .assign(to: \.showPasswordLengthError, on: self)
            .store(in: &cancellables)
    }
    
    func resetPassword() {
        guard !isButtonDisabled else { return }
        
        Task {
            await store.resetPassword(token: token, newPassword: newPassword, email: email)
            await MainActor.run {
                if !store.isLoading {
                    shouldDismiss = true
                }
            }
        }
    }
}
