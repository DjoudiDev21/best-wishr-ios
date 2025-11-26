import SwiftUI

struct LoginScreen: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var registerViewModel: RegisterViewModel
    @ObservedObject var forgotPasswordViewModel: ForgotPasswordViewModel
    @ObservedObject var resetPasswordViewModel: ResetPasswordViewModel
    @ObservedObject var socialAuthViewModel: SocialAuthViewModel
    @ObservedObject var authStore: AuthStore
    @EnvironmentObject var urlManager: URLManager
    @State private var showRegister = false
    @State private var showForgotPassword = false
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
                    
                    TitleSection()
                    
                    Spacer()
                }
                .frame(maxHeight: 200)
                
                VStack(spacing: 0) {
                    LoginFormView(
                        viewModel: loginViewModel,
                        socialAuthViewModel: socialAuthViewModel,
                        store: authStore,
                        onSignUpTap: { showRegister = true },
                        onForgotPasswordTap: { showForgotPassword = true }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showRegister) {
            RegisterScreen(viewModel: registerViewModel, store: authStore)
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordScreen(
                viewModel: forgotPasswordViewModel,
                store: authStore
            )
        }
        .sheet(isPresented: $urlManager.shouldShowResetPassword) {
            ResetPasswordScreen(
                viewModel: resetPasswordViewModel,
                store: authStore
            )
        }
        .onReceive(urlManager.$activeDestination) { destination in
            if case .resetPassword(_, _) = destination {
                urlManager.setResetPasswordMode(true)
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
