import SwiftUI
import Combine

struct ErrorHandler: ViewModifier {
    @ObservedObject private var errorHandler = GlobalErrorHandler.shared
    @ObservedObject private var resendCenter = ResendNotificationCenter.shared
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showBanner = false
    @State private var emailBannerType: ResendEmailType?
    private var cancellables = Set<AnyCancellable>()
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $errorHandler.isShowingError) {
                Button("OK") {
                    errorHandler.dismissError()
                }
                
                if let error = errorHandler.currentError, error.shouldRetry {
                    Button("Retry") {
                        errorHandler.dismissError()
                    }
                }
            } message: {
                if let error = errorHandler.currentError {
                    Text(error.userFriendlyMessage)
                }
            }
            .onReceive(errorHandler.errorSubject) { presentation in
                handleErrorPresentation(presentation)
            }
            .onReceive(resendCenter.dismissPublisher) { _ in
                withAnimation(.spring()) {
                    showBanner = false
                }
            }
            .overlay(
                // Header banner overlay
                VStack {
                    if showBanner, let emailType = emailBannerType {
                        ResendEmailBannerView(
                            emailType: emailType,
                            onAction: { emailType in
                                handleBannerAction(emailType: emailType)
                            },
                            onDismiss: {
                                withAnimation {
                                    showBanner = false
                                }
                            },
                            isLoading: resendCenter.isLoading,
                            isSuccess: resendCenter.isSuccess
                        )
                    }
                    
                    Spacer()
                }
                .allowsHitTesting(showBanner), 
                alignment: .top
            )
            .overlay(
                // Toast overlay
                Group {
                    if showToast {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                
                                Text(toastMessage)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                                
                                Button("Dismiss") {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 8)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            )
    }
    
    private func handleErrorPresentation(_ presentation: ErrorPresentation) {
        switch presentation.mode {
        case .alert:
            // Already handled by the alert modifier above
            break
            
        case .banner:
            handleBannerPresentation(presentation)
            
        case .toast:
            toastMessage = presentation.error.userFriendlyMessage
            withAnimation(.spring()) {
                showToast = true
            }
            
            // Auto-dismiss after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    showToast = false
                }
            }
            
        case .silent:
            // Silent errors don't show any UI
            break
        }
    }
    
    private func handleBannerPresentation(_ presentation: ErrorPresentation) {
        guard let context = presentation.context,
              let email = context["email"] as? String,
              let bannerErrorType = context["errorType"] as? BannerErrorType else {
            return
        }
                
        emailBannerType = createResendEmailType(from: bannerErrorType, email: email)
        
        withAnimation(.spring()) {
            showBanner = true
        }
    }
    
    private func createResendEmailType(from bannerErrorType: BannerErrorType, email: String) -> ResendEmailType {
        switch bannerErrorType {
        case .forgotPassword:
            return .forgotPassword(email: email)
        case .emailVerification, .loginUnverified, .verificationExpired:
            return .emailVerification(email: email)
        }
    }
    
    private func handleBannerAction(emailType: ResendEmailType) {
        switch emailType {
        case .emailVerification(let email):
            ResendNotificationCenter.shared.requestResend(.emailVerification(email: email))
        case .forgotPassword(let email):
            ResendNotificationCenter.shared.requestResend(.forgotPassword(email: email))
        }
    }
}

extension View {
    func withErrorHandling() -> some View {
        self.modifier(ErrorHandler())
    }
}
