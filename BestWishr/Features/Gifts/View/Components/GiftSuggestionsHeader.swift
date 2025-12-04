import SwiftUI

struct GiftSuggestionsHeader: View {
    let contactName: String?
    let eventType: EventType
    let hasContent: Bool
    let onViewAll: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Gift Suggestions")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                if let contactName = contactName {
                    Text("For \(contactName)'s \(eventType.rawValue)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                } else {
                    Text("For \(eventType.rawValue)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if hasContent {
                Button(action: onViewAll) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                    }
                }
            }
        }
    }
}
