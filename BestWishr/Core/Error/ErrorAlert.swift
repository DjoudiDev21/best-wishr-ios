import SwiftUI

struct ErrorHandler: ViewModifier {
    @ObservedObject private var errorHandler = GlobalErrorHandler.shared
    @State private var showToast = false
    @State private var toastMessage = ""
    
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
            // Banner errors are handled by specific UI components (like verification banner)
            // No additional UI needed here as the banner is shown in LoginForm
            break
            
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
}

extension View {
    func withErrorHandling() -> some View {
        self.modifier(ErrorHandler())
    }
}
