import Foundation

enum AgeGroup: String, CaseIterable {
    case child = "0-12"
    case teen = "13-19" 
    case adult = "20-64"
    case senior = "65+"
}

protocol GiftRepository {
    // Core CRUD operations
    func getAllGifts() async throws -> [Gift]
    func getGift(by id: String) async throws -> Gift?
    func createGift(_ gift: Gift) async throws -> Gift
    func updateGift(_ gift: Gift) async throws -> Gift
    func deleteGift(id: String) async throws
    
    // Gift suggestions (core feature)
    func generateSuggestions(contactId: String, eventType: EventType) async throws -> [Gift]
    func generateGeneralSuggestions(eventType: EventType, ageGroup: AgeGroup?, gender: String?) async throws -> [Gift]
    
    // Wishlist management
    func getWishlistedGifts() async throws -> [Gift]
    func saveToWishlist(_ gift: Gift) async throws -> Gift
    func removeFromWishlist(giftId: String) async throws
    
    // Purchase management
    func getPurchasedGifts() async throws -> [Gift]
    func togglePurchased(giftId: String) async throws -> Gift
    
    // Search and filtering
    func getGiftsForContact(contactId: String) async throws -> [Gift]
    func getGiftsForEvent(eventId: String) async throws -> [Gift]
    func getGiftsByCategory(_ category: GiftCategory) async throws -> [Gift]
    func searchGifts(query: String) async throws -> [Gift]
    
    // Future e-commerce features
    func trackPrice(giftId: String) async throws -> Gift
    func getPriceHistory(giftId: String) async throws -> [PricePoint]
    func purchaseGift(giftId: String, purchaseData: PurchaseData) async throws -> PurchaseResult
}