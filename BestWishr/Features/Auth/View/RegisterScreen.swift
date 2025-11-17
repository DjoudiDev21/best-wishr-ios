import SwiftUI

struct RegisterScreen: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var store: AuthStore
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimating = false
    @State private var showFloatingIcons = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            FloatingIconsBackground(
                isAnimating: $isAnimating,
                showFloatingIcons: $showFloatingIcons
            )
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Spacer()
                    
                    AppLogoView(isAnimating: $isAnimating)
                    
                    AuthTitleSection(
                        title: "Join Celebrations",
                        subtitle: "Create memories that last forever"
                    )
                    
                    Spacer()
                }
                .frame(maxHeight: 200)
                
                VStack(spacing: 0) {
                    RegisterFormView(
                        firstName: $viewModel.firstname,
                        lastName: $viewModel.lastname,
                        email: $viewModel.email,
                        password: $viewModel.password,
                        confirmPassword: $viewModel.confirmPassword,
                        agreeToTerms: $viewModel.agreeToTerms,
                        isLoading: .constant(store.isLoading),
                        onCreateAccount: { viewModel.register() },
                        onSignInTap: { dismiss() }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                isAnimating = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.5)) {
                showFloatingIcons = true
            }
        }
    }
}
