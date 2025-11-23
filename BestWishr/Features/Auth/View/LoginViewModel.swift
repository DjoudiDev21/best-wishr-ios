import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isButtonDisabled = true
    @Published var needsEmailVerification = false
    @Published var emailForResend = ""
    
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
    
    func resendVerificationEmail() {
        guard !emailForResend.isEmpty else {
            return
        }
        
        Task {
            ResendNotificationCenter.shared.setLoading(true)
            ResendNotificationCenter.shared.setSuccess(false)
            await store.resendVerificationEmail(email: emailForResend)
            ResendNotificationCenter.shared.setLoading(false)
            ResendNotificationCenter.shared.setSuccess(true)
        }
    }
    
    func dismissVerificationBanner() {
        needsEmailVerification = false
        emailForResend = ""
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
        
        store.$lastLoginFailedDueToUnverifiedEmail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] needsVerification in
                if needsVerification {
                    self?.checkIfVerificationNeeded()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func checkIfVerificationNeeded() {
        needsEmailVerification = true
        
        // Use email from store (extracted from verification URL)
        emailForResend = store.emailForVerificationResend.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Trigger global header banner
        GlobalErrorHandler.shared.handle(
            .authentication("Email verification required"),
            presentationMode: .banner,
            context: ["email": emailForResend]
        )
    }
    
    private func observeResendNotifications() {
        ResendNotificationCenter.shared.resendPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                self?.resendVerificationEmail()
            }
            .store(in: &cancellables)
    }
}
