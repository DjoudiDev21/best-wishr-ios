import Foundation

protocol GiftRepositoryProtocol {
    // Gift suggestions
    func generateSuggestions(from eventData: EventCreationData, preferences: [String]?, maxSuggestions: Int?) async throws -> [Gift]
    
    // Wishlist management
    func saveToWishlist(_ gift: Gift) async throws -> Gift
    func getWishlistedGifts() async throws -> [Gift]
}
