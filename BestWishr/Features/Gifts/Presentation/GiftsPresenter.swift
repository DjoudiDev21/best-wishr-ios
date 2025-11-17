import Foundation
import Combine

@MainActor
class GiftsPresenter: ObservableObject {
    private let generatePersonalizedSuggestionsUseCase: GeneratePersonalizedGiftSuggestionsUseCase
    private let generateGeneralSuggestionsUseCase: GenerateGeneralGiftSuggestionsUseCase
    private let saveGiftToWishlistUseCase: SaveGiftToWishlistUseCase
    private let getSavedGiftsUseCase: GetSavedGiftsUseCase
    private let markGiftAsPurchasedUseCase: MarkGiftAsPurchasedUseCase
    
    @Published var suggestions: [Gift] = []
    @Published var wishlistedGifts: [Gift] = []
    @Published var purchasedGifts: [Gift] = []
    @Published var isLoadingSuggestions = false
    @Published var isLoadingWishlist = false
    @Published var error: String? = nil
    
    init(
        generatePersonalizedSuggestionsUseCase: GeneratePersonalizedGiftSuggestionsUseCase,
        generateGeneralSuggestionsUseCase: GenerateGeneralGiftSuggestionsUseCase,
        saveGiftToWishlistUseCase: SaveGiftToWishlistUseCase,
        getSavedGiftsUseCase: GetSavedGiftsUseCase,
        markGiftAsPurchasedUseCase: MarkGiftAsPurchasedUseCase
    ) {
        self.generatePersonalizedSuggestionsUseCase = generatePersonalizedSuggestionsUseCase
        self.generateGeneralSuggestionsUseCase = generateGeneralSuggestionsUseCase
        self.saveGiftToWishlistUseCase = saveGiftToWishlistUseCase
        self.getSavedGiftsUseCase = getSavedGiftsUseCase
        self.markGiftAsPurchasedUseCase = markGiftAsPurchasedUseCase
    }
    
    // MARK: - Gift Suggestions
    
    func generatePersonalizedSuggestions(for contactId: String, eventType: EventType) async {
        isLoadingSuggestions = true
        error = nil
        
        do {
            let newSuggestions = try await generatePersonalizedSuggestionsUseCase.execute(for: contactId, eventType: eventType)
            suggestions = newSuggestions
        } catch {
            self.error = "Failed to generate personalized suggestions: \(error.localizedDescription)"
        }
        
        isLoadingSuggestions = false
    }
    
    func generateGeneralSuggestions(for eventType: EventType, ageGroup: AgeGroup? = nil, gender: String? = nil) async {
        isLoadingSuggestions = true
        error = nil
        
        do {
            let newSuggestions = try await generateGeneralSuggestionsUseCase.execute(for: eventType, ageGroup: ageGroup, gender: gender)
            suggestions = newSuggestions
        } catch {
            self.error = "Failed to generate suggestions: \(error.localizedDescription)"
        }
        
        isLoadingSuggestions = false
    }
    
    // MARK: - Wishlist Management
    
    func loadWishlistedGifts() async {
        isLoadingWishlist = true
        error = nil
        
        do {
            let gifts = try await getSavedGiftsUseCase.execute()
            wishlistedGifts = gifts.filter { !$0.isPurchased }
            purchasedGifts = gifts.filter { $0.isPurchased }
        } catch {
            self.error = "Failed to load wishlist: \(error.localizedDescription)"
        }
        
        isLoadingWishlist = false
    }
    
    func saveToWishlist(_ gift: Gift) async {
        do {
            // Check if gift is already wishlisted to toggle
            if isGiftWishlisted(gift.id) {
                // Remove from wishlist
                wishlistedGifts.removeAll { $0.id == gift.id }
            } else {
                // Add to wishlist
                let savedGift = try await saveGiftToWishlistUseCase.execute(gift: gift)
                wishlistedGifts.append(savedGift)
            }
        } catch {
            self.error = "Failed to save gift to wishlist: \(error.localizedDescription)"
        }
    }
    
    func togglePurchased(giftId: String) async {
        do {
            let updatedGift = try await markGiftAsPurchasedUseCase.execute(giftId: giftId)
            
            // Update local state
            if let index = wishlistedGifts.firstIndex(where: { $0.id == giftId }) {
                wishlistedGifts[index] = updatedGift
            }
            
            // Manage purchased list
            if updatedGift.isPurchased {
                if !purchasedGifts.contains(where: { $0.id == giftId }) {
                    purchasedGifts.append(updatedGift)
                }
            } else {
                purchasedGifts.removeAll { $0.id == giftId }
            }
        } catch {
            self.error = "Failed to update gift status: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Helper Methods
    
    func clearSuggestions() {
        suggestions = []
    }
    
    func clearError() {
        error = nil
    }
    
    func isGiftWishlisted(_ giftId: String) -> Bool {
        wishlistedGifts.contains { $0.id == giftId }
    }
    
    func isGiftPurchased(_ giftId: String) -> Bool {
        purchasedGifts.contains { $0.id == giftId }
    }
}
