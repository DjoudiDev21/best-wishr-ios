import Foundation
import Combine

final class ForgotPasswordViewModel: ObservableObject {
    @Published var email = "abdelkrim.djoudi.dev@gmail.com"
    @Published var isButtonDisabled = true
    @Published var shouldDismiss = false
    
    private let store: AuthStore
    private var cancellables = Set<AnyCancellable>()

    init(store: AuthStore) {
        self.store = store
        setupBindings()
        observeResendNotifications()
    }
    
    private func setupBindings() {
        $email
            .map { email in
                return email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .assign(to: \.isButtonDisabled, on: self)
            .store(in: &cancellables)
    }
    
    func sendResetInstructions() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        shouldDismiss = false
        
        Task {
            await store.forgotPassword(email: trimmedEmail)
            
            await MainActor.run {
                if !store.isLoading {
                    shouldDismiss = true
                }
            }
        }
    }
    
    private func observeResendNotifications() {
        ResendNotificationCenter.shared.resendPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requestType in
                if case .forgotPassword(let email) = requestType {
                    self?.resendForgotPasswordEmail(email: email)
                }
            }
            .store(in: &cancellables)
    }
    
    func resendForgotPasswordEmail(email: String) {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        Task {
            ResendNotificationCenter.shared.setLoading(true)
            ResendNotificationCenter.shared.setSuccess(false)
            await store.forgotPassword(email: email, showToast: false)
            ResendNotificationCenter.shared.setLoading(false)
            ResendNotificationCenter.shared.setSuccess(true)
        }
    }
}
