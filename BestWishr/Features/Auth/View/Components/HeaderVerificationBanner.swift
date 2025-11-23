import SwiftUI

struct HeaderVerificationBanner: View {
    let email: String
    let onResend: (String) -> Void
    let onDismiss: () -> Void
    let isLoading: Bool
    let isSuccess: Bool
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Status icon
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(isSuccess ? .green : .orange)
                    .font(.system(size: 16, weight: .semibold))
                
                // Message
                VStack(alignment: .leading, spacing: 2) {
                    Text(isSuccess ? "Verification Email Sent!" : "Email Verification Required")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(isSuccess ? "Check your inbox at **\(email)**" : "Check your inbox or **resend** to \(email)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 8) {
                    // Resend button (only show if not in success state)
                    if !isSuccess {
                        Button(action: {
                            onResend(email)
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
                                Text(isLoading ? "Sending" : "Resend")
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
                            .fill(isSuccess ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(isSuccess ? Color.green.opacity(0.3) : Color.orange.opacity(0.3))
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
        HeaderVerificationBanner(
            email: "user@example.com",
            onResend: { _ in },
            onDismiss: { },
            isLoading: false,
            isSuccess: false
        )
        
        Spacer()
        
        Text("Content below banner")
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
}
