import SwiftUI

struct LoginForm: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var store: AuthStore
    let onSignUpTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
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
                    text: $viewModel.email
                )
                
                FormFieldView(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $viewModel.password,
                    isSecure: true,
                    trailingButton: FormFieldTrailingButton(
                        title: "Forgot?",
                        action: {
                            // TODO: Implement forgot password
                        }
                    )
                )
                
                PrimaryButton(
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
                    // TODO: Implement Apple Sign In
                }
            }
            
            SignUpPrompt(action: onSignUpTap)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    // Placeholder preview
    VStack {
        Text("LoginForm Preview Unavailable")
            .font(.headline)
        Text("Provide preview stubs for AuthViewModel and AuthStore or run the app.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
    .padding()
}