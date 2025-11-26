import Foundation

final class HttpGiftRepository: GiftRepository {
    private let httpClient: HttpClientProtocol
    
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    // MARK: - Core CRUD operations
    func getAllGifts() async throws -> [Gift] {
        let gifts: [Gift] = try await httpClient.get(.listGifts)
        return gifts.sorted { $0.title < $1.title }
    }
    
    func getGift(by id: String) async throws -> Gift? {
        let allGifts = try await getAllGifts()
        return allGifts.first { $0.id == id }
    }
    
    func createGift(_ gift: Gift) async throws -> Gift {
        return try await httpClient.post(.createGift, body: gift)
    }
    
    func updateGift(_ gift: Gift) async throws -> Gift {
        return try await httpClient.put(.updateGift(gift.id), body: gift)
    }
    
    func deleteGift(id: String) async throws {
        try await httpClient.delete(.deleteGift(id))
    }
    
    // MARK: - Gift suggestions (core feature)
    func generateSuggestions(contactId: String, eventType: EventType) async throws -> [Gift] {
        let request = GiftSuggestionRequest(contactId: contactId, eventType: eventType, isPersonalized: true)
        let suggestions: [Gift] = try await httpClient.post(.generateGiftSuggestions, body: request)
        return suggestions
    }
    
    func generateGeneralSuggestions(eventType: EventType, ageGroup: AgeGroup?, gender: String?) async throws -> [Gift] {
        let request = GeneralGiftSuggestionRequest(eventType: eventType, ageGroup: ageGroup, gender: gender)
        let suggestions: [Gift] = try await httpClient.post(.generateGiftSuggestions, body: request)
        return suggestions
    }
    
    // MARK: - Wishlist management
    func getWishlistedGifts() async throws -> [Gift] {
        let allGifts = try await getAllGifts()
        return allGifts.filter { $0.isWishlisted }.sorted { $0.title < $1.title }
    }
    
    func saveToWishlist(_ gift: Gift) async throws -> Gift {
        let request = WishlistRequest(giftId: gift.id, action: .add)
        return try await httpClient.post(.saveToWishlist, body: request)
    }
    
    func removeFromWishlist(giftId: String) async throws {
        try await httpClient.delete(.removeFromWishlist(giftId))
    }
    
    // MARK: - Purchase management
    func getPurchasedGifts() async throws -> [Gift] {
        let allGifts = try await getAllGifts()
        return allGifts.filter { $0.isPurchased }.sorted { $0.title < $1.title }
    }
    
    func togglePurchased(giftId: String) async throws -> Gift {
        // This would typically be a specific endpoint for toggling purchase status
        guard let gift = try await getGift(by: giftId) else {
            throw GiftError.notFound
        }
        
        let updatedGift = Gift(
            id: gift.id,
            title: gift.title,
            description: gift.description,
            price: gift.price,
            currency: gift.currency,
            category: gift.category,
            tags: gift.tags,
            url: gift.url,
            imageURL: gift.imageURL,
            isWishlisted: gift.isWishlisted,
            isPurchased: !gift.isPurchased,
            contactId: gift.contactId,
            eventId: gift.eventId,
            notes: gift.notes,
            createdAt: gift.createdAt,
            updatedAt: Date()
        )
        return try await updateGift(updatedGift)
    }
    
    // MARK: - Search and filtering
    func getGiftsForContact(contactId: String) async throws -> [Gift] {
        let allGifts = try await getAllGifts()
        return allGifts.filter { $0.contactId == contactId }.sorted { $0.title < $1.title }
    }
    
    func getGiftsForEvent(eventId: String) async throws -> [Gift] {
        let allGifts = try await getAllGifts()
        return allGifts.filter { $0.eventId == eventId }.sorted { $0.title < $1.title }
    }
    
    func getGiftsByCategory(_ category: GiftCategory) async throws -> [Gift] {
        let allGifts = try await getAllGifts()
        return allGifts.filter { $0.category == category }.sorted { $0.title < $1.title }
    }
    
    func searchGifts(query: String) async throws -> [Gift] {
        let allGifts = try await getAllGifts()
        let lowercasedQuery = query.lowercased()
        
        return allGifts.filter { gift in
            gift.title.lowercased().contains(lowercasedQuery) ||
            gift.description?.lowercased().contains(lowercasedQuery) == true
        }.sorted { $0.title < $1.title }
    }
    
    // MARK: - Future e-commerce features
    func trackPrice(giftId: String) async throws -> Gift {
        // This would be a specific endpoint for price tracking
        guard let gift = try await getGift(by: giftId) else {
            throw GiftError.notFound
        }
        return gift
    }
    
    func getPriceHistory(giftId: String) async throws -> [PricePoint] {
        // This would be a specific endpoint for price history
        // For now, return empty array as this is a future feature
        return []
    }
    
    func purchaseGift(giftId: String, purchaseData: PurchaseData) async throws -> PurchaseResult {
        // This would be a specific endpoint for purchasing
        // For now, throw not implemented error as this is a future feature
        throw GiftError.notImplemented
    }
}

// MARK: - Request DTOs
private struct GiftSuggestionRequest: Codable {
    let contactId: String
    let eventType: EventType
    let isPersonalized: Bool
}

private struct GeneralGiftSuggestionRequest: Codable {
    let eventType: EventType
    let ageGroup: AgeGroup?
    let gender: String?
}

private struct WishlistRequest: Codable {
    let giftId: String
    let action: WishlistAction
}

private enum WishlistAction: String, Codable {
    case add, remove
}

// MARK: - Gift Errors
enum GiftError: LocalizedError {
    case notFound
    case notImplemented
    case invalidData(String)
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Gift not found"
        case .notImplemented:
            return "Feature not yet implemented"
        case .invalidData(let message):
            return message
        case .networkError:
            return "Network connection error"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}