import SwiftUI

@main
struct BestWishrApp: App {
    @StateObject private var appStore: AppStore
    @StateObject private var urlManager: URLManager
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var registerViewModel: RegisterViewModel
    @StateObject private var forgotPasswordViewModel: ForgotPasswordViewModel
    @StateObject private var socialAuthViewModel: SocialAuthViewModel
    @StateObject private var contactsViewModel: ContactsViewModel
    @StateObject private var addContactViewModel: AddContactViewModel

    init() {
        let appStore = AppStore()
        _appStore = StateObject(wrappedValue: appStore)
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(store: appStore.authStore))
        _registerViewModel = StateObject(wrappedValue: RegisterViewModel(store: appStore.authStore))
        _forgotPasswordViewModel = StateObject(wrappedValue: ForgotPasswordViewModel(store: appStore.authStore))
        _socialAuthViewModel = StateObject(wrappedValue: SocialAuthViewModel(store: appStore.authStore))
        _contactsViewModel = StateObject(wrappedValue: ContactsViewModel(contactsStore: appStore.contactsStore, appStats: appStore.appStats))
        _addContactViewModel = StateObject(wrappedValue: AddContactViewModel(contactsStore: appStore.contactsStore))
        _urlManager = StateObject(wrappedValue: URLManager())
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if appStore.isAuthenticated {
                    if appStore.isInitializing {
                        InitializationScreen()
                            .environmentObject(appStore)
                    } else {
                        HomeScreen()
                            .environmentObject(contactsViewModel)
                            .environmentObject(addContactViewModel)
                            .environmentObject(appStore)
                            .withErrorHandling()
                    }
                } else {
                    LoginScreen(
                        loginViewModel: loginViewModel,
                        registerViewModel: registerViewModel,
                        forgotPasswordViewModel: forgotPasswordViewModel,
                        resetPasswordViewModel: ResetPasswordViewModel(
                            store: appStore.authStore,
                            token: urlManager.resetPasswordToken,
                            email: urlManager.resetPasswordEmail
                        ),
                        socialAuthViewModel: socialAuthViewModel,
                        authStore: appStore.authStore,
                    )
                    .environmentObject(appStore)
                    .environmentObject(urlManager)
                    .withErrorHandling()
                }
                
                // Toast overlay on top of everything
                ToastOverlay()
            }
            .onOpenURL { url in
                handleURL(url: url)
            }
        }
    }
    
    private func handleURL(url: URL) {
        if urlManager.handleURL(url: url) {
            if let destination = urlManager.activeDestination {
                handleDeeplink(destination)
            }
        }
    }

    private func handleDeeplink(_ destination: URLDestination) {
        Task {
            switch destination {
                case .verifyEmail(let token, let email):
                    
                    // Check token validity before making API call
                    if JWTDecoder.isTokenValid(token) {
                        urlManager.setProcessingState(true)
                        _ = await appStore.authStore.verifyEmailAndLogin(token: token, email: email)
                        urlManager.setProcessingState(false)
                        urlManager.clearActiveDestination()
                    } else {
                        // Token is expired, reuse existing error handling logic
                        appStore.authStore.handleExpiredVerificationToken(email: email)
                        urlManager.clearActiveDestination()
                    }

                case .resetPassword(let token, let email):
                    // Trigger the reset password UI in LoginScreen
                    urlManager.setResetPasswordMode(true)
        }
    }
}
    
}
