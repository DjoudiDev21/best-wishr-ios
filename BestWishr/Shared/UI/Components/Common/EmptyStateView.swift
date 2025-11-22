import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.3))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Text(message)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.65, green: 0.3, blue: 0.8),
                                    Color(red: 0.75, green: 0.4, blue: 0.9)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                }
            }
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    VStack(spacing: 50) {
        EmptyStateView(
            icon: "person.3",
            title: "No Contacts Yet",
            message: "Start building your contact list to keep track of important dates and celebrations.",
            actionTitle: "Add Your First Contact"
        ) { }
        
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results Found",
            message: "Try adjusting your search terms or clear filters to see more contacts."
        )
    }
}
