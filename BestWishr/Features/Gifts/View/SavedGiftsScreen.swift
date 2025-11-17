import SwiftUI

struct SavedGiftsScreen: View {
    @EnvironmentObject var appStore: AppStore
    @State private var selectedTab: SavedGiftsTab = .saved
    
    enum SavedGiftsTab: String, CaseIterable {
        case saved = "Saved"
        case purchased = "Purchased"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SavedGiftsHeader(
                    stats: appStore.giftsStore.giftStats,
                    selectedTab: $selectedTab
                )
                
                SavedGiftsContent(
                    selectedTab: selectedTab,
                    isLoading: appStore.giftsStore.isLoadingWishlist,
                    savedGifts: appStore.giftsStore.filteredWishlistedGifts,
                    purchasedGifts: appStore.giftsStore.filteredPurchasedGifts
                )
            }
            .navigationTitle("My Gift Ideas")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .task {
                await appStore.giftsStore.loadWishlistedGifts()
            }
        }
    }
}

#Preview {
    SavedGiftsScreen()
        .environmentObject(AppStore())
}
