import SwiftUI

struct LoginFormView: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var socialAuthViewModel: SocialAuthViewModel
    @ObservedObject var store: AuthStore
    let onSignUpTap: () -> Void
    let onForgotPasswordTap: () -> Void
    
    @FocusState private var focusedField: LoginField?
    
    enum LoginField {
        case email
        case password
    }
    
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
                
                FormFieldView<LoginField>(
                    title: "Email",
                    placeholder: "you@example.com",
                    text: $viewModel.email,
                    inputType: .email,
                    focusBinding: $focusedField,
                    focusValue: LoginField.email
                )
                
                FormFieldView<LoginField>(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $viewModel.password,
                    isSecure: true,
                    trailingButton: FormFieldTrailingButton(
                        title: "Forgot?",
                        action: onForgotPasswordTap
                    ),
                    focusBinding: $focusedField,
                    focusValue: LoginField.password
                )
                
                SubmitButton(
                    title: "Sign In",
                    action: {
                        // Dismiss keyboard before submitting
                        focusedField = nil
                        
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
                    socialAuthViewModel.googleLogin()
                }
                
                SocialLoginButton(icon: "applelogo") {
                    print("🎯 LoginFormView: Apple button tapped!")
                    socialAuthViewModel.appleLogin()
                }
            }
            
            SignUpPrompt(action: onSignUpTap)
        }
        .padding(.horizontal, 24)
        .onSubmit {
            // Handle return key submission
            if focusedField == .email {
                focusedField = .password
            } else if focusedField == .password {
                // Dismiss keyboard and submit form
                focusedField = nil
                if !viewModel.isButtonDisabled {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.login()
                    }
                }
            }
        }
    }
}
