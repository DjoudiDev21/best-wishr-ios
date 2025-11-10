import SwiftUI

struct GiftSuggestionCard: View {
    @EnvironmentObject var appStore: AppStore
    let gift: Gift
    
    var body: some View {
        VStack(spacing: 8) {
            GiftCategoryIcon(category: gift.category)
            
            GiftCardInfo(gift: gift)
            
            GiftCardActionButton(
                isWishlisted: appStore.giftsStore.isGiftWishlisted(gift.id)
            ) {
                Task {
                    await appStore.giftsStore.saveToWishlist(gift)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(gift.category.color.opacity(0.2), lineWidth: 1)
                )
        )
        .onTapGesture {
            // Future: Open gift detail view or external link
        }
    }
}

struct GiftCategoryIcon: View {
    let category: GiftCategory
    
    var body: some View {
        ZStack {
            Circle()
                .fill(category.color.opacity(0.2))
                .frame(width: 40, height: 40)
            
            Image(systemName: category.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(category.color)
        }
    }
}

struct GiftCardInfo: View {
    let gift: Gift
    
    var body: some View {
        VStack(spacing: 4) {
            Text(gift.title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            if let price = gift.formattedPrice {
                Text(price)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(gift.category.color)
            }
        }
    }
}

struct GiftCardActionButton: View {
    let isWishlisted: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Image(systemName: isWishlisted ? "heart.fill" : "heart")
                    .font(.system(size: 10, weight: .medium))
                
                Text(isWishlisted ? "Saved" : "Save")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
            }
            .foregroundColor(isWishlisted ? .red : .secondary)
        }
    }
}

#Preview {
    GiftSuggestionCard(
        gift: Gift(
            title: "Wireless Headphones",
            description: "Premium noise-cancelling headphones",
            price: 299.99,
            category: .electronics,
            tags: ["music", "tech", "wireless"]
        )
    )
    .environmentObject(AppStore())
    .padding()
}