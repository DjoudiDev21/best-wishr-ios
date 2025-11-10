import SwiftUI

struct RegisterScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var isLoading = false
    @State private var isAnimating = false
    @State private var showFloatingIcons = false
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        agreeToTerms &&
        email.contains("@")
    }
    
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
                    
                    VStack(spacing: 4) {
                        Text("Join Celebrations")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
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
                        
                        Text("Create memories that last forever")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: 200)
                
                VStack(spacing: 0) {
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
                            
                            // Password Requirements
                            if !password.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Password must contain:")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                                    
                                    HStack {
                                        Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(password.count >= 6 ? .green : .gray)
                                            .font(.caption)
                                        Text("At least 6 characters")
                                            .font(.caption)
                                            .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                                    }
                                }
                                .padding(.top, 4)
                            }
                            
                            // Terms and Conditions
                            HStack(alignment: .top, spacing: 12) {
                                Button(action: {
                                    agreeToTerms.toggle()
                                }) {
                                    Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                        .foregroundColor(agreeToTerms ? Color(red: 0.65, green: 0.3, blue: 0.8) : .gray)
                                        .font(.title3)
                                }
                                
                                Text("I agree to the **Terms of Service** and **Privacy Policy**")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                            }
                            .padding(.top, 8)
                            
                            SubmitButton(
                                title: "Create Account",
                                action: {
                                    // TODO: Implement registration logic
                                },
                                isLoading: isLoading,
                                isDisabled: !isFormValid
                            )
                        }
                        
                        HStack {
                            Text("Already have an account?")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                            
                            Button("Sign In") {
                                dismiss()
                            }
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                        }
                    }
                    .padding(.horizontal, 24)
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

#Preview {
    RegisterScreen()
}
