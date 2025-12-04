import Foundation
import SwiftUI
import Combine

@MainActor
final class SavedGiftsViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: GiftCategory?
    @Published var wishlistedGifts: [Gift] = []
    @Published var purchasedGifts: [Gift] = []
    @Published var filteredWishlistedGifts: [Gift] = []
    @Published var filteredPurchasedGifts: [Gift] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var giftStats = GiftStats(totalWishlisted: 0, totalPurchased: 0, totalValue: 0, mostPopularCategory: .other)
    
    private let giftsStore: GiftsStore
    private var cancellables = Set<AnyCancellable>()
    
    init(giftsStore: GiftsStore) {
        self.giftsStore = giftsStore
        setupBindings()
    }
    
    private func setupBindings() {
        giftsStore.$wishlistedGifts
            .receive(on: DispatchQueue.main)
            .assign(to: \.wishlistedGifts, on: self)
            .store(in: &cancellables)
        
        giftsStore.$purchasedGifts
            .receive(on: DispatchQueue.main)
            .assign(to: \.purchasedGifts, on: self)
            .store(in: &cancellables)

        giftsStore.$isLoadingWishlist
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        giftsStore.$error
            .receive(on: DispatchQueue.main)
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
        
        // Update store search text when ViewModel search text changes
        $searchText
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchText, on: giftsStore)
            .store(in: &cancellables)
        
        // Update store selected category when ViewModel category changes
        $selectedCategory
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedCategory, on: giftsStore)
            .store(in: &cancellables)
    }
    
    func loadWishlistedGifts() async {
        await giftsStore.loadWishlistedGifts()
    }
    
    func clearError() {
        giftsStore.clearError()
    }
}
