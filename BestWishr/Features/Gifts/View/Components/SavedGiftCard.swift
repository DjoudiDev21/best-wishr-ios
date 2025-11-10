import SwiftUI

struct SavedGiftCard: View {
    @EnvironmentObject var appStore: AppStore
    let gift: Gift
    let isPurchasedTab: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            GiftCategoryIcon(category: gift.category)
            
            SavedGiftCardInfo(gift: gift)
            
            Spacer()
            
            SavedGiftCardActions(
                gift: gift,
                isPurchased: gift.isPurchased
            ) {
                Task {
                    await appStore.giftsStore.togglePurchased(giftId: gift.id)
                }
            } onExternalLink: {
                // Future: Open external link
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(gift.category.color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct SavedGiftCardInfo: View {
    let gift: Gift
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(gift.title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            if let description = gift.description {
                Text(description)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack(spacing: 8) {
                if let price = gift.formattedPrice {
                    Text(price)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(gift.category.color)
                }
                
                Text(gift.category.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(gift.category.color.opacity(0.1))
                    .cornerRadius(8)
            }
            
            if let contactId = gift.contactId,
               let contactName = getContactName(contactId) {
                HStack(spacing: 4) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Text("For \(contactName)")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    @EnvironmentObject private var appStore: AppStore
    
    private func getContactName(_ contactId: String) -> String? {
        appStore.contactsStore.contacts.first { $0.id == contactId }?.fullName
    }
}

struct SavedGiftCardActions: View {
    let gift: Gift
    let isPurchased: Bool
    let onTogglePurchased: () -> Void
    let onExternalLink: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: onTogglePurchased) {
                Image(systemName: isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isPurchased ? .green : .secondary)
            }
            
            if gift.url != nil {
                Button(action: onExternalLink) {
                    Image(systemName: "link")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                }
            }
        }
    }
}

#Preview {
    SavedGiftCard(
        gift: Gift(
            title: "Wireless Headphones",
            description: "Premium noise-cancelling headphones perfect for music lovers",
            price: 299.99,
            category: .electronics,
            tags: ["music", "tech", "wireless"],
            url: "https://amazon.com/headphones",
            isPurchased: false,
            contactId: "1"
        ),
        isPurchasedTab: false
    )
    .environmentObject(AppStore())
    .padding()
}