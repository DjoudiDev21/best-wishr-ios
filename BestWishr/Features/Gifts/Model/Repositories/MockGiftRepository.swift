import Foundation

class MockGiftRepository: GiftRepositoryProtocol {
    private var gifts: [Gift] = []
    private var wishlistedGifts: [Gift] = []
    
    init() {
        loadMockData()
    }
    
    // MARK: - Gift Suggestions
    func generateSuggestions(from eventData: EventCreationData, preferences: [String]? = nil, maxSuggestions: Int? = 5) async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second for "AI generation"
        
        let baseGifts = getGiftsForEventType(eventData.type)
        let maxCount = maxSuggestions ?? 5
        return Array(baseGifts.prefix(maxCount))
    }
    
    // MARK: - Wishlist Management
    func saveToWishlist(_ gift: Gift) async throws -> Gift {
        try await Task.sleep(nanoseconds: 400_000_000)
        let wishlistedGift = Gift(
            id: gift.id,
            title: gift.title,
            description: gift.description,
            price: gift.price,
            currency: gift.currency,
            category: gift.category,
            tags: gift.tags,
            url: gift.url,
            imageURL: gift.imageURL,
            isWishlisted: true,
            isPurchased: gift.isPurchased,
            contactId: gift.contactId,
            eventId: gift.eventId,
            notes: gift.notes,
            createdAt: gift.createdAt,
            updatedAt: Date()
        )
        
        if !wishlistedGifts.contains(where: { $0.id == gift.id }) {
            wishlistedGifts.append(wishlistedGift)
        }
        return wishlistedGift
    }
    
    func getWishlistedGifts() async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return wishlistedGifts
    }
    
}

// MARK: - Private Helper Methods

private extension MockGiftRepository {
    func loadMockData() {
        gifts = createMockGifts()
    }
    
    func createMockGifts() -> [Gift] {
        return [
            // Birthday gifts
            Gift(title: "Wireless Headphones", description: "Premium noise-cancelling headphones", price: 299.99, category: .electronics, tags: ["music", "tech", "wireless"], url: "https://amazon.com/headphones"),
            Gift(title: "Coffee Table Book", description: "Beautiful photography book", price: 45.00, category: .books, tags: ["coffee table", "photography"], url: "https://amazon.com/book"),
            Gift(title: "Silk Scarf", description: "Luxurious silk scarf", price: 89.99, category: .fashion, tags: ["fashion", "luxury"], url: "https://amazon.com/scarf"),
            
            // Anniversary gifts
            Gift(title: "Wine Gift Set", description: "Premium wine selection", price: 120.00, category: .food, tags: ["wine", "romantic"], url: "https://amazon.com/wine"),
            Gift(title: "Couple's Spa Day", description: "Relaxing spa experience for two", price: 350.00, category: .experiences, tags: ["spa", "couples"], url: "https://spa.com/couples"),
            
            // Wedding gifts
            Gift(title: "Kitchen Stand Mixer", description: "Professional stand mixer", price: 400.00, category: .home, tags: ["kitchen", "cooking"], url: "https://amazon.com/mixer"),
            Gift(title: "Fine China Set", description: "Elegant dinnerware set", price: 250.00, category: .home, tags: ["dinnerware", "elegant"], url: "https://amazon.com/china"),
            
            // General gifts
            Gift(title: "Board Game", description: "Fun family board game", price: 35.00, category: .games, tags: ["family", "fun"], url: "https://amazon.com/boardgame"),
            Gift(title: "Running Shoes", description: "Performance running shoes", price: 150.00, category: .sports, tags: ["running", "fitness"], url: "https://amazon.com/shoes"),
            Gift(title: "Skincare Set", description: "Premium skincare collection", price: 80.00, category: .beauty, tags: ["skincare", "beauty"], url: "https://amazon.com/skincare"),
            Gift(title: "Travel Backpack", description: "Durable travel backpack", price: 120.00, category: .travel, tags: ["travel", "durable"], url: "https://amazon.com/backpack")
        ]
    }
    
    func getGiftsForEventType(_ eventType: EventType) -> [Gift] {
        switch eventType {
        case .birthday:
            return gifts.filter { gift in
                gift.tags.contains("music") || gift.tags.contains("fashion") || 
                gift.tags.contains("fun") || gift.category == .electronics ||
                gift.category == .books || gift.category == .games
            }
        case .wedding:
            return gifts.filter { gift in
                gift.category == .home || gift.tags.contains("kitchen") ||
                gift.tags.contains("elegant")
            }
        default:
            return Array(gifts.prefix(8))
        }
    }
}
