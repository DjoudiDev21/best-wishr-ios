import SwiftUI

struct ToastView: View {
    let notification: AppNotification
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon based on type
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
            
            // Message
            Text(notification.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var iconName: String {
        switch notification.type {
        case .success:
            return "checkmark.circle.fill"
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        }
    }
    
    private var backgroundColor: Color {
        switch notification.type {
        case .success:
            return Color.green
        case .info:
            return Color.blue
        case .warning:
            return Color.orange
        }
    }
}

struct ToastOverlay: View {
    @ObservedObject var notificationHandler = GlobalNotificationHandler.shared
    
    var body: some View {
        VStack {
            if notificationHandler.isShowingNotification,
               let notification = notificationHandler.currentNotification {
                
                ToastView(notification: notification)
                    .padding(.horizontal, 20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                    .onTapGesture {
                        notificationHandler.dismissNotification()
                    }
            }
            
            Spacer()
        }
        .animation(.easeInOut(duration: 0.3), value: notificationHandler.isShowingNotification)
    }
}

#Preview {
    VStack(spacing: 20) {
        ToastView(notification: AppNotification(message: "Account created successfully!", type: .success))
        ToastView(notification: AppNotification(message: "Please check your email", type: .info))
        ToastView(notification: AppNotification(message: "Please verify your information", type: .warning))
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}