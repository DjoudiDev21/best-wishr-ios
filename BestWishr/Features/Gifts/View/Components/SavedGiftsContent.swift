import SwiftUI

struct SavedGiftsContent: View {
    let selectedTab: SavedGiftsScreen.SavedGiftsTab
    let isLoading: Bool
    let savedGifts: [Gift]
    let purchasedGifts: [Gift]
    
    var body: some View {
        if isLoading {
            SavedGiftsLoadingState()
        } else {
            switch selectedTab {
            case .saved:
                SavedGiftsList(gifts: savedGifts, isPurchasedTab: false)
            case .purchased:
                SavedGiftsList(gifts: purchasedGifts, isPurchasedTab: true)
            }
        }
    }
}

struct SavedGiftsLoadingState: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading your gift ideas...")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SavedGiftsList: View {
    let gifts: [Gift]
    let isPurchasedTab: Bool
    
    var body: some View {
        if gifts.isEmpty {
            SavedGiftsEmptyState(isPurchasedTab: isPurchasedTab)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(gifts) { gift in
                        SavedGiftCard(gift: gift, isPurchasedTab: isPurchasedTab)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .refreshable {
                // Refresh gifts
            }
        }
    }
}

struct SavedGiftsEmptyState: View {
    let isPurchasedTab: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: isPurchasedTab ? "checkmark.circle" : "heart")
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(isPurchasedTab ? "No Purchased Gifts" : "No Saved Gifts")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(isPurchasedTab 
                     ? "Gifts you mark as purchased will appear here"
                     : "Save gift suggestions to keep track of ideas for your events")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    VStack {
        SavedGiftsLoadingState()
        
        SavedGiftsEmptyState(isPurchasedTab: false)
    }
}