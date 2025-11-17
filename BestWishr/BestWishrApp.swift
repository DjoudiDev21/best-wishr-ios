import SwiftUI

@main
struct BestWishrApp: App {
    @StateObject private var appStore = AppStore()
    @StateObject private var urlManager = URLManager()

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
                        viewModel: AuthViewModel(
                            store:  appStore.authStore,
                        ),
                        store: appStore.authStore
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
                handleEmailVerification(destination)
            }
        }
    }
    
    private func handleEmailVerification(_ destination: URLDestination) {
        Task {
            switch destination {
            case .verifyEmail(let token, let email):
                urlManager.setProcessingState(true)
                let success = await appStore.authStore.verifyEmailAndLogin(token: token, email: email)
                urlManager.setProcessingState(false)
                urlManager.clearActiveDestination()
                
            case .resetPassword(let token, let email):
                // Handle password reset if needed in future
                urlManager.clearActiveDestination()
            }
        }
    }
}
