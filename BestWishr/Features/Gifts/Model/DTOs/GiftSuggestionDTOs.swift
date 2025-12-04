import Foundation

struct GenerateGiftSuggestionsRequest: Codable {
    let eventType: String
    let eventDate: String
    let contactId: String?
    let eventTitle: String?
    let eventDescription: String?
    let budget: String?
    let preferences: [String]?
    let maxSuggestions: Int?
    
    init(eventType: EventType, eventDate: Date, contactId: String? = nil, eventTitle: String? = nil, eventDescription: String? = nil, budget: String? = nil, preferences: [String]? = nil, maxSuggestions: Int? = 5) {
        self.eventType = eventType.rawValue
        let formatter = ISO8601DateFormatter()
        self.eventDate = formatter.string(from: eventDate)
        self.contactId = contactId
        self.eventTitle = eventTitle
        self.eventDescription = eventDescription
        self.budget = budget
        self.preferences = preferences
        self.maxSuggestions = maxSuggestions
    }
    
    init(from eventData: EventCreationData, preferences: [String]? = nil, maxSuggestions: Int? = 5) {
        self.eventType = eventData.type.rawValue
        let formatter = ISO8601DateFormatter()
        self.eventDate = formatter.string(from: eventData.date)
        self.contactId = eventData.contactId
        self.eventTitle = eventData.title.isEmpty ? nil : eventData.title
        self.eventDescription = eventData.description.isEmpty ? nil : eventData.description
        self.budget = nil // Can be added to EventCreationData if needed
        self.preferences = preferences
        self.maxSuggestions = maxSuggestions
    }
}

struct GiftSuggestionContextDto: Decodable {
    let contactName: String?
    let eventType: String
    let eventTitle: String
    let relationship: String?
    let date: String
}

enum SuggestionSource: String, CaseIterable, Decodable {
    case ai = "AI"
    case ruleBased = "RULE_BASED"
    case userCreated = "USER_CREATED"
}

struct PublicGiftSuggestion: Decodable {
    let id: String
    let title: String
    let description: String
    let category: GiftCategory
    let priceRange: String?
    let reasoning: String?
    let confidence: Double
    let source: SuggestionSource
    let purchaseLinks: [String]?
    let imageUrl: String?
    let isBookmarked: Bool
    let isPurchased: Bool
    let createdAt: String
}

struct GiftSuggestionResponse: Decodable {
    let suggestions: [PublicGiftSuggestion]
    let context: GiftSuggestionContextDto
    let generatedAt: String
    let canRegenerate: Bool
    let totalCount: Int
}


struct RateSuggestionRequest: Codable {
    let suggestionId: String
    let rating: Double
    let feedback: String?
    
    init(suggestionId: String, rating: Double, feedback: String? = nil) {
        self.suggestionId = suggestionId
        self.rating = rating
        self.feedback = feedback
    }
}

struct RatingSuggestionResponse: Codable {
    let id: String
    let suggestionId: String
    let userId: String
    let rating: Double
    let feedback: String?
    let createdAt: String
    let updatedAt: String
}

struct UpdateSuggestionRequest: Codable {
    let suggestionId: String
    let isBookmarked: Bool?
    let isPurchased: Bool?
    let notes: String?
    let customPrice: Double?
    let customImageURL: String?
    
    init(suggestionId: String, isBookmarked: Bool? = nil, isPurchased: Bool? = nil, notes: String? = nil, customPrice: Double? = nil, customImageURL: String? = nil) {
        self.suggestionId = suggestionId
        self.isBookmarked = isBookmarked
        self.isPurchased = isPurchased
        self.notes = notes
        self.customPrice = customPrice
        self.customImageURL = customImageURL
    }
}

struct GiftSuggestionFilters: Codable {
    let eventId: String?
    let contactId: String?
    let category: String?
    let isBookmarked: Bool?
    let isPurchased: Bool?
    let minPrice: Double?
    let maxPrice: Double?
    let tags: [String]?
    let searchQuery: String?
    let limit: Int?
    let offset: Int?
    
    init(eventId: String? = nil, contactId: String? = nil, category: String? = nil, isBookmarked: Bool? = nil, isPurchased: Bool? = nil, minPrice: Double? = nil, maxPrice: Double? = nil, tags: [String]? = nil, searchQuery: String? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.eventId = eventId
        self.contactId = contactId
        self.category = category
        self.isBookmarked = isBookmarked
        self.isPurchased = isPurchased
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.tags = tags
        self.searchQuery = searchQuery
        self.limit = limit
        self.offset = offset
    }
}

// MARK: - PublicGiftSuggestion Extensions

extension PublicGiftSuggestion {
    func toGift() -> Gift {
        let formatter = ISO8601DateFormatter()
        
        // Parse price from priceRange (e.g., "$10-$25" -> midpoint = 17.5)
        let price = parsePriceFromRange(priceRange)
        
        return Gift(
            id: id,
            title: title,
            description: description,
            price: price,
            currency: "USD", // Default currency
            category: category,
            tags: [], // Gift suggestions don't have tags from API
            url: purchaseLinks?.first, // Use first purchase link as URL
            imageURL: imageUrl,
            isWishlisted: isBookmarked, // Map isBookmarked to isWishlisted
            isPurchased: isPurchased,
            contactId: nil, // Not provided in suggestion response
            eventId: nil, // Not provided in suggestion response
            notes: reasoning, // Use reasoning as notes
            createdAt: formatter.date(from: createdAt) ?? Date(),
            updatedAt: formatter.date(from: createdAt) ?? Date() // Use createdAt as fallback for updatedAt
        )
    }
    
    private func parsePriceFromRange(_ priceRange: String?) -> Double {
        guard let priceRange = priceRange else { return 0.0 }
        
        // Handle formats like "$10-$25", "$10", "10-25", etc.
        let cleanRange = priceRange.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " ", with: "")
        
        if cleanRange.contains("-") {
            let components = cleanRange.split(separator: "-").compactMap { Double($0) }
            if components.count == 2 {
                return (components[0] + components[1]) / 2.0 // Return midpoint
            }
        } else {
            if let singlePrice = Double(cleanRange) {
                return singlePrice
            }
        }
        
        return 0.0 // Default fallback
    }
}
