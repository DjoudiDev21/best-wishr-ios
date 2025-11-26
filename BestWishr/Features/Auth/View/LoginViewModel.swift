import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var email = "abdelkrim.djoudi.dev@gmail.com"
    @Published var password = "Gstarraw95100?"
    @Published var isButtonDisabled = true
    @Published var needsEmailVerification = false
    
    private let store: AuthStore
    private var cancellables = Set<AnyCancellable>()

    init(store: AuthStore) {
        self.store = store
        setupBindings()
        observeAuthState()
        observeResendNotifications()
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
    
    func resendVerificationEmail(email: String) {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard !store.isResendingVerification else { return }
        
        Task {
            ResendNotificationCenter.shared.setLoading(true)
            ResendNotificationCenter.shared.setSuccess(false)
            await store.resendVerificationEmail(email: email)
            ResendNotificationCenter.shared.setLoading(false)
            ResendNotificationCenter.shared.setSuccess(true)
        }
    }
    
    func dismissVerificationBanner() {
        needsEmailVerification = false
    }
    
    private func observeAuthState() {
        store.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.dismissVerificationBanner()
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func observeResendNotifications() {
        ResendNotificationCenter.shared.resendPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requestType in
                if case .emailVerification(let email) = requestType {
                    self?.resendVerificationEmail(email: email)
                }
            }
            .store(in: &cancellables)
    }
}
