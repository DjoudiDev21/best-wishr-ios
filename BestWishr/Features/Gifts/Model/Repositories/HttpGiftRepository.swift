import Foundation

final class HttpGiftRepository: GiftRepositoryProtocol {
    private let httpClient: HttpClientProtocol
    
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    // MARK: - Gift Suggestions
    func generateSuggestions(from eventData: EventCreationData, preferences: [String]? = nil, maxSuggestions: Int? = 5) async throws -> [Gift] {
        let request = GenerateGiftSuggestionsRequest(
            from: eventData,
            preferences: preferences,
            maxSuggestions: maxSuggestions
        )
        let response: GiftSuggestionResponse = try await httpClient.post(.generateGiftSuggestions, body: request)
        return response.suggestions.map { $0.toGift() }
    }
    
    // MARK: - Wishlist Management
    func saveToWishlist(_ gift: Gift) async throws -> Gift {
        let request = WishlistRequest(giftId: gift.id, action: .add)
        let response: Gift = try await httpClient.post(.saveToWishlist, body: request)
        return response
    }
    
    func getWishlistedGifts() async throws -> [Gift] {
        let response: GiftSuggestionResponse = try await httpClient.get(.getBookmarkedSuggestions)
        return response.suggestions.map { $0.toGift() }
    }
    
    func togglePurchased(giftId: String) async throws -> Gift {
        // Since we can't toggle, let's mark as purchased
        let response: Gift = try await httpClient.patch(.markSuggestionAsPurchased(giftId), body: EmptyBody())
        return response
    }
}

// MARK: - Request DTOs
private struct WishlistRequest: Codable {
    let giftId: String
    let action: WishlistAction
}

private enum WishlistAction: String, Codable {
    case add, remove
}

private struct EmptyBody: Codable {}

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
