import SwiftUI

struct ResetPasswordFormView: View {
    @Binding var newPassword: String
    @Binding var confirmPassword: String
    @Binding var isLoading: Bool
    let showPasswordMismatchError: Bool
    let showPasswordLengthError: Bool
    let isButtonDisabled: Bool
    let onResetPassword: () -> Void
    let onSignInTap: () -> Void
    
    @FocusState private var focusedField: ResetPasswordField?
    
    enum ResetPasswordField {
        case newPassword
        case confirmPassword
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Text("New Password")
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
                
                FormFieldView<ResetPasswordField>(
                    title: "New Password",
                    placeholder: "Enter new password",
                    text: $newPassword,
                    isSecure: true,
                    focusBinding: $focusedField,
                    focusValue: ResetPasswordField.newPassword
                )
                
                FormFieldView<ResetPasswordField>(
                    title: "Confirm Password",
                    placeholder: "Confirm new password",
                    text: $confirmPassword,
                    isSecure: true,
                    focusBinding: $focusedField,
                    focusValue: ResetPasswordField.confirmPassword
                )
                
                if showPasswordMismatchError {
                    Text("Passwords do not match")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }
                
                if showPasswordLengthError {
                    Text("Password must be at least 6 characters")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }
                
                SubmitButton(
                    title: "Reset Password",
                    action: {
                        // Dismiss keyboard before submitting
                        focusedField = nil
                        onResetPassword()
                    },
                    isLoading: isLoading,
                    isDisabled: isButtonDisabled
                )
            }
            
            HStack {
                Text("Remember your password?")
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
        .onSubmit {
            // Handle return key submission
            if focusedField == .newPassword {
                focusedField = .confirmPassword
            } else if focusedField == .confirmPassword {
                if !isButtonDisabled {
                    // Dismiss keyboard and submit form
                    focusedField = nil
                    onResetPassword()
                }
            }
        }
    }
}