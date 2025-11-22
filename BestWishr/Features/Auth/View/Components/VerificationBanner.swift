import SwiftUI

struct VerificationBanner: View {
    let email: String
    let onResend: (String) -> Void
    let onDismiss: () -> Void
    let isLoading: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "envelope.badge")
                .foregroundColor(.orange)
                .font(.system(size: 16, weight: .medium))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Email not verified")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("Please check your email or resend verification")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(action: {
                print("🔄 VerificationBanner: Resend button tapped for email: '\(email)'")
                print("🔄 VerificationBanner: Calling onResend callback")
                onResend(email)
                print("🔄 VerificationBanner: onResend callback completed")
            }) {
                HStack(spacing: 4) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.7)
                    }
                    Text(isLoading ? "Sending..." : "Resend")
                }
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.orange)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(6)
            .disabled(isLoading)
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.secondary)
                    .font(.system(size: 12, weight: .medium))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}