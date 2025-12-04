import Foundation
import Combine

@MainActor
class GiftsStore: ObservableObject {
    @Published var suggestions: [Gift] = []
    @Published var wishlistedGifts: [Gift] = []
    @Published var purchasedGifts: [Gift] = []
    @Published var isLoadingSuggestions = false
    @Published var isLoadingWishlist = false
    @Published var error: String? = nil
    
    // Filtering and search
    @Published var searchText: String = ""
    @Published var selectedCategory: GiftCategory? = nil
    
    private let presenter: GiftsPresenter
    private var cancellables = Set<AnyCancellable>()
    
    init(presenter: GiftsPresenter) {
        self.presenter = presenter
        bindToPresenter()
    }
    
    private func bindToPresenter() {
        presenter.$suggestions
            .receive(on: DispatchQueue.main)
            .assign(to: \.suggestions, on: self)
            .store(in: &cancellables)
        
        presenter.$wishlistedGifts
            .receive(on: DispatchQueue.main)
            .assign(to: \.wishlistedGifts, on: self)
            .store(in: &cancellables)
        
        presenter.$purchasedGifts
            .receive(on: DispatchQueue.main)
            .assign(to: \.purchasedGifts, on: self)
            .store(in: &cancellables)
        
        presenter.$isLoadingSuggestions
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoadingSuggestions, on: self)
            .store(in: &cancellables)
        
        presenter.$isLoadingWishlist
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoadingWishlist, on: self)
            .store(in: &cancellables)
        
        presenter.$error
            .receive(on: DispatchQueue.main)
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Gift Suggestions
    
    func generateSuggestions(from eventData: EventCreationData, preferences: [String]? = nil) async {
        await presenter.generateSuggestions(from: eventData, preferences: preferences)
    }
    
    // MARK: - Wishlist Management
    
    func loadWishlistedGifts() async {
        await presenter.loadWishlistedGifts()
    }
    
    func saveToWishlist(_ gift: Gift) async {
        await presenter.saveToWishlist(gift)
    }
    
    // MARK: - Helper Methods
    
    func clearSuggestions() {
        presenter.clearSuggestions()
    }
    
    func clearError() {
        presenter.clearError()
    }
    
    func isGiftWishlisted(_ giftId: String) -> Bool {
        presenter.isGiftWishlisted(giftId)
    }
    
    func isGiftPurchased(_ giftId: String) -> Bool {
        presenter.isGiftPurchased(giftId)
    }
    
    // MARK: - Computed Properties for Filtering
    
    var filteredWishlistedGifts: [Gift] {
        var filtered = wishlistedGifts
        
        // Apply search filter
        if !searchText.isEmpty {
            let lowercasedSearch = searchText.lowercased()
            filtered = filtered.filter { gift in
                gift.title.lowercased().contains(lowercasedSearch) ||
                gift.description?.lowercased().contains(lowercasedSearch) == true ||
                gift.tags.contains { $0.lowercased().contains(lowercasedSearch) }
            }
        }
        
        // Apply category filter
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        return filtered.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var filteredPurchasedGifts: [Gift] {
        var filtered = purchasedGifts
        
        // Apply search filter
        if !searchText.isEmpty {
            let lowercasedSearch = searchText.lowercased()
            filtered = filtered.filter { gift in
                gift.title.lowercased().contains(lowercasedSearch) ||
                gift.description?.lowercased().contains(lowercasedSearch) == true ||
                gift.tags.contains { $0.lowercased().contains(lowercasedSearch) }
            }
        }
        
        // Apply category filter
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        return filtered.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    // MARK: - Stats
    
    var giftStats: GiftStats {
        GiftStats(
            totalWishlisted: wishlistedGifts.count,
            totalPurchased: purchasedGifts.count,
            totalValue: wishlistedGifts.compactMap { $0.price }.reduce(0, +),
            mostPopularCategory: mostPopularCategory
        )
    }
    
    private var mostPopularCategory: GiftCategory {
        let categories = wishlistedGifts.map { $0.category }
        let categoryCount = Dictionary(grouping: categories) { $0 }
        return categoryCount.max(by: { $0.value.count < $1.value.count })?.key ?? .other
    }
}

struct GiftStats {
    let totalWishlisted: Int
    let totalPurchased: Int
    let totalValue: Double
    let mostPopularCategory: GiftCategory
}
