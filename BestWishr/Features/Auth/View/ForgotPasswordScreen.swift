import SwiftUI

struct ForgotPasswordScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
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
                    
                    VStack(spacing: 4) {
                        Text("Reset Password")
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
                        
                        Text("Enter your email to receive reset instructions")
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
                            
                            FormFieldView(
                                title: "Email",
                                placeholder: "you@example.com",
                                text: $email
                            )
                            
                            SubmitButton(
                                title: "Send Reset Instructions",
                                action: {
                                    // TODO: Implement forgot password logic
                                },
                                isDisabled: email.isEmpty
                            )
                        }
                        
                        HStack {
                            Text("Remember your password?")
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
    ForgotPasswordScreen()
}