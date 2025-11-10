import Foundation

class MockGiftRepository: GiftRepository {
    private var gifts: [Gift] = []
    private var wishlistedGifts: [Gift] = []
    private var purchasedGifts: [Gift] = []
    
    init() {
        loadMockData()
    }
    
    // MARK: - Core CRUD Operations
    
    func getAllGifts() async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        return gifts
    }
    
    func getGift(by id: String) async throws -> Gift? {
        try await Task.sleep(nanoseconds: 200_000_000)
        return gifts.first { $0.id == id }
    }
    
    func createGift(_ gift: Gift) async throws -> Gift {
        try await Task.sleep(nanoseconds: 300_000_000)
        gifts.append(gift)
        return gift
    }
    
    func updateGift(_ gift: Gift) async throws -> Gift {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let index = gifts.firstIndex(where: { $0.id == gift.id }) {
            gifts[index] = gift
        }
        return gift
    }
    
    func deleteGift(id: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        gifts.removeAll { $0.id == id }
        wishlistedGifts.removeAll { $0.id == id }
        purchasedGifts.removeAll { $0.id == id }
    }
    
    // MARK: - Gift Suggestions
    
    func generateSuggestions(contactId: String, eventType: EventType) async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second for "AI generation"
        
        // Mock personalized suggestions based on event type
        let baseGifts = getGiftsForEventType(eventType)
        return Array(baseGifts.prefix(8)) // Return top 8 suggestions
    }
    
    func generateGeneralSuggestions(eventType: EventType, ageGroup: AgeGroup?, gender: String?) async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 800_000_000)
        
        var suggestions = getGiftsForEventType(eventType)
        
        // Filter by age group if provided
        if let ageGroup = ageGroup {
            suggestions = filterByAgeGroup(suggestions, ageGroup: ageGroup)
        }
        
        // Could filter by gender in the future
        
        return Array(suggestions.prefix(12)) // Return top 12 general suggestions
    }
    
    // MARK: - Wishlist Management
    
    func getWishlistedGifts() async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return wishlistedGifts
    }
    
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
    
    func removeFromWishlist(giftId: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        wishlistedGifts.removeAll { $0.id == giftId }
    }
    
    // MARK: - Purchase Management
    
    func getPurchasedGifts() async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return purchasedGifts
    }
    
    func togglePurchased(giftId: String) async throws -> Gift {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        if let gift = wishlistedGifts.first(where: { $0.id == giftId }) {
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
            
            // Update in wishlist
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
            
            return updatedGift
        }
        
        throw NSError(domain: "GiftRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Gift not found"])
    }
    
    // MARK: - Search and Filtering
    
    func getGiftsForContact(contactId: String) async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return wishlistedGifts.filter { $0.contactId == contactId }
    }
    
    func getGiftsForEvent(eventId: String) async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return wishlistedGifts.filter { $0.eventId == eventId }
    }
    
    func getGiftsByCategory(_ category: GiftCategory) async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return gifts.filter { $0.category == category }
    }
    
    func searchGifts(query: String) async throws -> [Gift] {
        try await Task.sleep(nanoseconds: 500_000_000)
        let lowercasedQuery = query.lowercased()
        return gifts.filter { gift in
            gift.title.lowercased().contains(lowercasedQuery) ||
            gift.description?.lowercased().contains(lowercasedQuery) == true ||
            gift.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
    
    // MARK: - Future E-commerce Features (Placeholder implementations)
    
    func trackPrice(giftId: String) async throws -> Gift {
        try await Task.sleep(nanoseconds: 400_000_000)
        // Future: Add price tracking functionality
        guard let gift = gifts.first(where: { $0.id == giftId }) else {
            throw NSError(domain: "GiftRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Gift not found"])
        }
        return gift
    }
    
    func getPriceHistory(giftId: String) async throws -> [PricePoint] {
        try await Task.sleep(nanoseconds: 300_000_000)
        // Future: Return actual price history
        return []
    }
    
    func purchaseGift(giftId: String, purchaseData: PurchaseData) async throws -> PurchaseResult {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        // Future: Implement actual purchase flow
        return PurchaseResult(
            success: false,
            orderId: nil,
            trackingNumber: nil,
            estimatedDelivery: nil,
            error: "Direct purchasing not yet implemented. Redirecting to external retailer.",
            externalURL: gifts.first(where: { $0.id == giftId })?.url
        )
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
            Gift(title: "Silk Scarf", description: "Luxurious silk scarf", price: 89.99, category: .clothing, tags: ["fashion", "luxury"], url: "https://amazon.com/scarf"),
            
            // Anniversary gifts  
            Gift(title: "Diamond Earrings", description: "Elegant diamond stud earrings", price: 599.99, category: .jewelry, tags: ["diamond", "elegant"], url: "https://amazon.com/earrings"),
            Gift(title: "Wine Gift Set", description: "Premium wine selection", price: 120.00, category: .food, tags: ["wine", "romantic"], url: "https://amazon.com/wine"),
            Gift(title: "Couple's Spa Day", description: "Relaxing spa experience for two", price: 350.00, category: .experiences, tags: ["spa", "couples"], url: "https://spa.com/couples"),
            
            // Wedding gifts
            Gift(title: "Kitchen Stand Mixer", description: "Professional stand mixer", price: 400.00, category: .home, tags: ["kitchen", "cooking"], url: "https://amazon.com/mixer"),
            Gift(title: "Fine China Set", description: "Elegant dinnerware set", price: 250.00, category: .home, tags: ["dinnerware", "elegant"], url: "https://amazon.com/china"),
            
            // General gifts
            Gift(title: "Board Game", description: "Fun family board game", price: 35.00, category: .toys, tags: ["family", "fun"], url: "https://amazon.com/boardgame"),
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
                gift.category == .books || gift.category == .toys
            }
        case .anniversary:
            return gifts.filter { gift in
                gift.tags.contains("romantic") || gift.tags.contains("luxury") ||
                gift.category == .jewelry || gift.category == .experiences ||
                gift.category == .food
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
    
    func filterByAgeGroup(_ gifts: [Gift], ageGroup: AgeGroup) -> [Gift] {
        switch ageGroup {
        case .child:
            return gifts.filter { $0.category == .toys || $0.tags.contains("fun") }
        case .teen:
            return gifts.filter { $0.category == .electronics || $0.category == .sports || $0.category == .books }
        case .adult:
            return gifts // Most gifts are suitable for adults
        case .senior:
            return gifts.filter { $0.category == .books || $0.category == .home || $0.category == .experiences }
        }
    }
}