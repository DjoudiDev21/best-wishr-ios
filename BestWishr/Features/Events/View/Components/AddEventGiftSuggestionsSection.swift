import SwiftUI

struct AddEventGiftSuggestionsSection: View {
    let eventData: EventCreationData
    @Binding var showingGiftSuggestions: Bool
    
    private var contactName: String? {
        guard eventData.contactId != nil else { return nil }
        // This would need AppStore access to get contact name, but for now we'll keep it simple
        return "Contact"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Gift Suggestions")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                    
                    if let contactName = contactName {
                        Text("Get ideas for \(contactName)'s \(eventData.eventType.rawValue)")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    } else {
                        Text("Get ideas for this \(eventData.eventType.rawValue)")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "gift")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.0))
            }
            
            // Gift Suggestions CTA
            Button(action: {
                showingGiftSuggestions = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.0))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Generate Gift Ideas")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("AI-powered suggestions based on the event")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Benefits list
            VStack(spacing: 8) {
                GiftSuggestionBenefit(
                    icon: "target",
                    text: "Personalized recommendations"
                )
                
                GiftSuggestionBenefit(
                    icon: "heart",
                    text: "Save ideas to your wishlist"
                )
                
                GiftSuggestionBenefit(
                    icon: "link",
                    text: "Direct links to purchase"
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct GiftSuggestionBenefit: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.0))
                .frame(width: 16)
            
            Text(text)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    VStack {
        AddEventGiftSuggestionsSection(
            eventData: EventCreationData(
                title: "John's Birthday",
                eventType: .birthday,
                contactId: "1"
            ),
            showingGiftSuggestions: .constant(false)
        )
        
        AddEventGiftSuggestionsSection(
            eventData: EventCreationData(
                title: "Anniversary Dinner",
                eventType: .anniversary
            ),
            showingGiftSuggestions: .constant(false)
        )
    }
    .padding()
}
