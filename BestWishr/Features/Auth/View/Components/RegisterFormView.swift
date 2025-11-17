import SwiftUI

struct RegisterFormView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var agreeToTerms: Bool
    @Binding var isLoading: Bool
    
    let onCreateAccount: () -> Void
    let onSignInTap: () -> Void
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        agreeToTerms &&
        email.contains("@")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create Account")
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
                
                HStack(spacing: 12) {
                    FormFieldView(
                        title: "First Name",
                        placeholder: "John",
                        text: $firstName
                    )
                    
                    FormFieldView(
                        title: "Last Name",
                        placeholder: "Doe",
                        text: $lastName
                    )
                }
                
                FormFieldView(
                    title: "Email",
                    placeholder: "you@example.com",
                    text: $email,
                    inputType: .email
                )
                
                FormFieldView(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $password,
                    isSecure: true
                )
                
                FormFieldView(
                    title: "Confirm Password",
                    placeholder: "Confirm your password",
                    text: $confirmPassword,
                    isSecure: true
                )
                
                if !confirmPassword.isEmpty && password != confirmPassword {
                    Text("Passwords don't match")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                PasswordRequirementsView(password: password)
                
                TermsAndConditionsView(agreeToTerms: $agreeToTerms)
                
                SubmitButton(
                    title: "Create Account",
                    action: onCreateAccount,
                    isLoading: isLoading,
                    isDisabled: !isFormValid
                )
            }
            
            HStack {
                Text("Already have an account?")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                
                Button("Sign In") {
                    onSignInTap()
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    RegisterFormView(
        firstName: .constant(""),
        lastName: .constant(""),
        email: .constant(""),
        password: .constant(""),
        confirmPassword: .constant(""),
        agreeToTerms: .constant(false),
        isLoading: .constant(false),
        onCreateAccount: {},
        onSignInTap: {}
    )
    .padding()
}