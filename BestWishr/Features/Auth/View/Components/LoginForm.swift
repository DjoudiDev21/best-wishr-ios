import SwiftUI

struct LoginForm: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var store: AuthStore
    let onSignUpTap: () -> Void
    let onForgotPasswordTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.needsEmailVerification {
                VerificationBanner(
                    email: viewModel.emailForResend,
                    onResend: { email in
                        print("🔄 LoginForm: VerificationBanner onResend callback received for email: '\(email)'")
                        viewModel.resendVerificationEmail()
                        print("🔄 LoginForm: viewModel.resendVerificationEmail() call completed")
                    },
                    onDismiss: {
                        print("❌ LoginForm: VerificationBanner onDismiss callback received")
                        viewModel.dismissVerificationBanner()
                    },
                    isLoading: store.isResendingVerification
                )
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome Back!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.65, green: 0.3, blue: 0.8),
                                Color(red: 0.75, green: 0.4, blue: 0.9)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                FormFieldView(
                    title: "Email",
                    placeholder: "you@example.com",
                    text: $viewModel.email,
                    inputType: .email
                )
                
                FormFieldView(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $viewModel.password,
                    isSecure: true,
                    trailingButton: FormFieldTrailingButton(
                        title: "Forgot?",
                        action: onForgotPasswordTap
                    )
                )
                
                SubmitButton(
                    title: "Sign In",
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            viewModel.login()
                        }
                    },
                    isLoading: store.isLoading,
                    isDisabled: viewModel.isButtonDisabled
                )
            }
            
            DividerWithText(text: "Or continue with")
            
            HStack(spacing: 10) {
                SocialLoginButton(icon: "globe") {
                    // TODO: Implement Google Sign In
                }
                
                SocialLoginButton(icon: "applelogo") {
                    Task {
                        do {
                            let appleAuthService = AppleAuthService()
                            let result = try await appleAuthService.auth()
                            
                            await store.appleAuth(
                                identityToken: result.identityToken,
                                authorizationCode: result.authorizationCode
                            )
                        } catch { }
                    }
                }
            }
            
            SignUpPrompt(action: onSignUpTap)
        }
        .padding(.horizontal, 24)
    }
}
