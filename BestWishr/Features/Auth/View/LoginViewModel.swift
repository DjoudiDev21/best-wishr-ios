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
        print("📧 LoginViewModel: resendVerificationEmail() called with email: '\(emailForResend)'")
        guard !emailForResend.isEmpty else { 
            print("❌ LoginViewModel: resendVerificationEmail() - email is empty, aborting")
            return 
        }
        
        Task {
            print("📤 LoginViewModel: Calling store.resendVerificationEmail with email: '\(emailForResend)'")
            await store.resendVerificationEmail(email: emailForResend)
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
        
        print("📧 LoginViewModel: Verification banner setup - needsEmailVerification: \(needsEmailVerification), emailForResend: '\(emailForResend)'")
    }
}
