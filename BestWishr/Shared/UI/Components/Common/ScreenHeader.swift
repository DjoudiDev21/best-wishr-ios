import SwiftUI

struct ScreenHeader: View {
    let title: String
    let subtitle: String?
    let actionIcon: String?
    let action: (() -> Void)?
    
    init(
        title: String,
        subtitle: String? = nil,
        actionIcon: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionIcon = actionIcon
        self.action = action
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
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
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                }
            }
            
            Spacer()
            
            if let actionIcon = actionIcon, let action = action {
                Button(action: action) {
                    Image(systemName: actionIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.65, green: 0.3, blue: 0.8),
                                    Color(red: 0.75, green: 0.4, blue: 0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        ScreenHeader(
            title: "My Contacts",
            subtitle: "24 contacts",
            actionIcon: "plus.circle.fill"
        ) {
            print("Action tapped")
        }
        
        ScreenHeader(
            title: "Events",
            subtitle: "5 upcoming"
        )
        
        ScreenHeader(title: "Settings")
    }
    .padding()
}