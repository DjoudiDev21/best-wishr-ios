import SwiftUI

@main
struct BestWishrApp: App {
    @StateObject private var appStore = AppStore()

    var body: some Scene {
        WindowGroup {
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
                .withErrorHandling()
            }
        }
    }
}
