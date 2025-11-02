import SwiftUI

struct ErrorAlert: ViewModifier {
    @ObservedObject private var errorHandler = GlobalErrorHandler.shared
    
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
    }
}

extension View {
    func withErrorHandling() -> some View {
        self.modifier(ErrorAlert())
    }
}