import SwiftUI

struct GiftSuggestionCard: View {
    @EnvironmentObject var appStore: AppStore
    let gift: Gift
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                GiftCategoryIcon(category: gift.category)
                
                GiftCardInfo(gift: gift)
            }
            
            Divider()
                .opacity(0.3)
            
            GiftCardActionButton(
                isWishlisted: appStore.giftsStore.isGiftWishlisted(gift.id)
            ) {
                Task {
                    await appStore.giftsStore.saveToWishlist(gift)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: gift.category.color.opacity(0.15), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [gift.category.color.opacity(0.3), gift.category.color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
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
                .fill(
                    LinearGradient(
                        colors: [category.color.opacity(0.3), category.color.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)
                .overlay(
                    Circle()
                        .stroke(category.color.opacity(0.4), lineWidth: 1)
                )
            
            Image(systemName: category.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(category.color)
        }
    }
}

struct GiftCardInfo: View {
    let gift: Gift
    
    var body: some View {
        VStack(spacing: 6) {
            Text(gift.title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            if let price = gift.formattedPrice {
                Text(price)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(gift.category.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(gift.category.color.opacity(0.1))
                    )
            }
        }
    }
}

struct GiftCardActionButton: View {
    let isWishlisted: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: isWishlisted ? "heart.fill" : "heart")
                    .font(.system(size: 12, weight: .medium))
                
                Text(isWishlisted ? "Saved" : "Save")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isWishlisted ? .white : Color(red: 0.65, green: 0.3, blue: 0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isWishlisted ? 
                        LinearGradient(
                            colors: [Color.red, Color.red.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.1), Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isWishlisted ? Color.clear : Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
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