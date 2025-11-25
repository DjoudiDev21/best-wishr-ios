import SwiftUI

enum ResendEmailType {
    case emailVerification(email: String)
    case forgotPassword(email: String)
    
    var email: String {
        switch self {
        case .emailVerification(let email),
             .forgotPassword(let email):
            return email
        }
    }
    
    var message: String {
        switch self {
        case .emailVerification:
            return "Email Verification Required"
        case .forgotPassword:
            return "Reset Password Link Expired"
        }
    }
    
    var subtitle: String {
        switch self {
        case .emailVerification(let email):
            return "Check your inbox or **resend** to \(email)"
        case .forgotPassword(let email):
            return "Your link has expired. **Request new** for \(email)"
        }
    }
    
    var actionButtonText: String {
        switch self {
        case .emailVerification:
            return "Resend"
        case .forgotPassword:
            return "Send New Link"
        }
    }
    
    var iconName: String {
        switch self {
        case .emailVerification:
            return "exclamationmark.triangle.fill"
        case .forgotPassword:
            return "exclamationmark.triangle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .emailVerification:
            return .orange
        case .forgotPassword:
            return .orange
        }
    }
}

struct ResendEmailBannerView: View {
    let emailType: ResendEmailType
    let onAction: (ResendEmailType) -> Void
    let onDismiss: () -> Void
    let isLoading: Bool
    let isSuccess: Bool
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Status icon
                Image(systemName: isSuccess ? "checkmark.circle.fill" : emailType.iconName)
                    .foregroundColor(isSuccess ? .green : emailType.iconColor)
                    .font(.system(size: 16, weight: .semibold))
                
                // Message
                VStack(alignment: .leading, spacing: 2) {
                    Text(isSuccess ? "\(emailType.actionButtonText) Email Sent!" : emailType.message)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(isSuccess ? "Check your inbox at **\(emailType.email)**" : emailType.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 8) {
                    // Action button (only show if not in success state)
                    if !isSuccess {
                        Button(action: {
                            onAction(emailType)
                        }) {
                            HStack(spacing: 4) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.7)
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                Text(isLoading ? "Sending" : emailType.actionButtonText)
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.blue)
                            )
                        }
                        .disabled(isLoading)
                        .opacity(isLoading ? 0.7 : 1.0)
                    }
                    
                    // Close button
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.system(size: 12, weight: .medium))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Rectangle()
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        Rectangle()
                            .fill(isSuccess ? Color.green.opacity(0.1) : emailType.iconColor.opacity(0.1))
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(isSuccess ? Color.green.opacity(0.3) : emailType.iconColor.opacity(0.3))
                                .frame(height: 1)
                        }
                    )
            )
        }
        .offset(y: isVisible ? 0 : -100)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

#Preview {
    VStack {
        ResendEmailBannerView(
            emailType: .emailVerification(email: "user@example.com"),
            onAction: { _ in },
            onDismiss: { },
            isLoading: false,
            isSuccess: false
        )
        
        Spacer()
        
        ResendEmailBannerView(
            emailType: .forgotPassword(email: "user@example.com"),
            onAction: { _ in },
            onDismiss: { },
            isLoading: false,
            isSuccess: false
        )
        
        Spacer()
        
        Text("Content below banners")
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
}
