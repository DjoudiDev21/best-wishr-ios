import SwiftUI

struct LoginCard: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var store: AuthStore
    let onSignUpTap: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
            .overlay(
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Welcome Back!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(red: 0.15, green: 0.1, blue: 0.2))
                            .padding(.top, 24)
                        
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
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            )
    }
}

#Preview {
    // Placeholder preview
    VStack {
        Text("LoginCard Preview Unavailable")
            .font(.headline)
        Text("Provide preview stubs for AuthViewModel and AuthStore or run the app.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
    .padding()
}