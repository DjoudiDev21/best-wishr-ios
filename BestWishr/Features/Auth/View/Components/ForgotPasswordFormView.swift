import SwiftUI

struct ForgotPasswordFormView: View {
    @Binding var email: String
    @Binding var isLoading: Bool
    let onSendInstructions: () -> Void
    let onSignInTap: () -> Void
    
    @FocusState private var focusedField: ForgotPasswordField?
    
    enum ForgotPasswordField {
        case email
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Email Address")
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
                
                FormFieldView<ForgotPasswordField>(
                    title: "Email",
                    placeholder: "you@example.com",
                    text: $email,
                    inputType: .email,
                    focusBinding: $focusedField,
                    focusValue: ForgotPasswordField.email
                )
                
                SubmitButton(
                    title: "Send Reset Instructions",
                    action: {
                        // Dismiss keyboard before submitting
                        focusedField = nil
                        onSendInstructions()
                    },
                    isLoading: isLoading,
                    isDisabled: email.isEmpty
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
            if !email.isEmpty {
                focusedField = nil
                onSendInstructions()
            }
        }
    }
}