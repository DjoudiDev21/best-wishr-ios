import Foundation
import Combine

@MainActor
final class SocialAuthViewModel: ObservableObject {
    @Published private(set) var isAppleAuthLoading = false
    @Published private(set) var isGoogleAuthLoading = false
    
    private let store: AuthStore
    private var cancellables = Set<AnyCancellable>()
    
    init(store: AuthStore) {
        self.store = store
    }
    
    func appleLogin() {
        guard !isAppleAuthLoading else { return }
        
        Task {
            isAppleAuthLoading = true
            print("🎯 SocialAuthViewModel: Starting Apple auth")
            
            do {
                let appleAuthService = AppleAuthService()
                let result = try await appleAuthService.auth()
                print("🎯 SocialAuthViewModel: Got Apple auth result, calling store")
                
                await store.appleAuth(
                    identityToken: result.identityToken,
                    authorizationCode: result.authorizationCode
                )
                print("🎯 SocialAuthViewModel: Apple auth completed successfully")
                
            } catch {
                print("🎯 SocialAuthViewModel: Apple auth failed: \(error)")
                // Let AuthStore handle the error with proper toast
                await store.handleAppleAuthError(error)
            }
            
            isAppleAuthLoading = false
        }
    }
    
    func googleLogin() {
        guard !isGoogleAuthLoading else { return }
        
        // TODO: Implement Google Sign In
        print("🎯 SocialAuthViewModel: Google auth not implemented yet")
    }
}