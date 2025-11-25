import SwiftUI

@main
struct BestWishrApp: App {
    @StateObject private var appStore: AppStore
    @StateObject private var urlManager: URLManager
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var registerViewModel: RegisterViewModel
    @StateObject private var forgotPasswordViewModel: ForgotPasswordViewModel

    init() {
        let appStore = AppStore()
        _appStore = StateObject(wrappedValue: appStore)
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(store: appStore.authStore))
        _registerViewModel = StateObject(wrappedValue: RegisterViewModel(store: appStore.authStore))
        _forgotPasswordViewModel = StateObject(wrappedValue: ForgotPasswordViewModel(store: appStore.authStore))
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
        print("🔗 BestWishrApp: Received URL: \(url)")
        if urlManager.handleURL(url: url) {
            print("🔗 BestWishrApp: URL handled successfully")
            if let destination = urlManager.activeDestination {
                print("🔗 BestWishrApp: Active destination: \(destination)")
                handleDeeplink(destination)
            } else {
                print("❌ BestWishrApp: No active destination found")
            }
        } else {
            print("❌ BestWishrApp: URL not handled")
        }
    }

    private func handleDeeplink(_ destination: URLDestination) {
        Task {
            switch destination {
                case .verifyEmail(let token, let email):
                    print("🔗 BestWishrApp: Processing email verification link")
                    
                    // Check token validity before making API call
                    if JWTDecoder.isTokenValid(token) {
                        print("🔗 BestWishrApp: Token is valid, proceeding with verification")
                        urlManager.setProcessingState(true)
                        _ = await appStore.authStore.verifyEmailAndLogin(token: token, email: email)
                        urlManager.setProcessingState(false)
                        urlManager.clearActiveDestination()
                    } else {
                        print("🔗 BestWishrApp: Token is expired, showing banner directly")
                        // Token is expired, reuse existing error handling logic
                        appStore.authStore.handleExpiredVerificationToken(email: email)
                        urlManager.clearActiveDestination()
                    }

                case .resetPassword(let token, let email):
                    print("🔗 BestWishrApp: Handling reset password deeplink - token: \(token.prefix(10))..., email: \(email)")
                    // Trigger the reset password UI in LoginScreen
                    urlManager.setResetPasswordMode(true)
        }
    }
}
    
}
