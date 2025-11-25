import SwiftUI

struct ResetPasswordScreen: View {
    @ObservedObject var viewModel: ResetPasswordViewModel
    @ObservedObject var store: AuthStore
    @EnvironmentObject var urlManager: URLManager
    @Environment(\.dismiss) private var dismiss
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
                        
                        Text("Enter your new password")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: 200)
                
                VStack(spacing: 0) {
                    ResetPasswordFormView(
                        newPassword: Binding(
                            get: { viewModel.newPassword },
                            set: { viewModel.newPassword = $0 }
                        ),
                        confirmPassword: Binding(
                            get: { viewModel.confirmPassword },
                            set: { viewModel.confirmPassword = $0 }
                        ),
                        isLoading: .constant(store.isLoading),
                        showPasswordMismatchError: viewModel.showPasswordMismatchError,
                        showPasswordLengthError: viewModel.showPasswordLengthError,
                        isButtonDisabled: viewModel.isButtonDisabled,
                        onResetPassword: {
                            viewModel.resetPassword()
                        },
                        onSignInTap: {
                            urlManager.clearActiveDestination()
                            dismiss()
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.shouldDismiss = false
            withAnimation(.easeInOut(duration: 1)) {
                isAnimating = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.5)) {
                showFloatingIcons = true
            }
        }
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                urlManager.clearActiveDestination()
                dismiss()
            }
        }
        .onDisappear {
            viewModel.shouldDismiss = false
        }
    }
}
