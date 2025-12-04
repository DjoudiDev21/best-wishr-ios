import Foundation

struct Gift: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String?
    let price: Double?
    let currency: String
    let category: GiftCategory
    let tags: [String]
    let url: String?
    let imageURL: String?
    let isWishlisted: Bool
    let isPurchased: Bool
    let contactId: String?
    let eventId: String?
    let notes: String?
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String? = nil,
        price: Double? = nil,
        currency: String = "USD",
        category: GiftCategory,
        tags: [String] = [],
        url: String? = nil,
        imageURL: String? = nil,
        isWishlisted: Bool = false,
        isPurchased: Bool = false,
        contactId: String? = nil,
        eventId: String? = nil,
        notes: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.currency = currency
        self.category = category
        self.tags = tags
        self.url = url
        self.imageURL = imageURL
        self.isWishlisted = isWishlisted
        self.isPurchased = isPurchased
        self.contactId = contactId
        self.eventId = eventId
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var formattedPrice: String? {
        guard let price = price else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: price))
    }
    
    var isForContact: Bool {
        contactId != nil
    }
    
    var isForEvent: Bool {
        eventId != nil
    }
}

enum GiftCategory: String, CaseIterable, Identifiable, Codable {
    case electronics = "ELECTRONICS"
    case books = "BOOKS"
    case fashion = "FASHION"
    case home = "HOME_DECOR"
    case experiences = "EXPERIENCES"
    case sports = "SPORTS"
    case beauty = "BEAUTY"
    case food = "FOOD_DRINKS"
    case hobbies = "HOBBIES"
    case sentimental = "SENTIMENTAL"
    case games = "GAMES"
    case travel = "TRAVEL"
    case healthWellness = "HEALTH_WELLNESS"
    case artCrafts = "ART_CRAFTS"
    case other = "OTHER"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .books: return "book"
        case .electronics: return "iphone"
        case .fashion: return "tshirt"
        case .sentimental: return "gem"
        case .home: return "house"
        case .games: return "gamecontroller"
        case .sports: return "sportscourt"
        case .beauty: return "sparkles"
        case .food: return "fork.knife"
        case .travel: return "airplane"
        case .experiences: return "ticket"
        case .hobbies: return "paintbrush"
        case .healthWellness: return "heart"
        case .artCrafts: return "paintpalette"
        case .other: return "gift"
        }
    }
    
    var color: Color {
        switch self {
        case .books: return Color(red: 0.8, green: 0.6, blue: 0.4)
        case .electronics: return Color(red: 0.2, green: 0.6, blue: 0.9)
        case .fashion: return Color(red: 0.9, green: 0.4, blue: 0.6)
        case .sentimental: return Color(red: 0.8, green: 0.8, blue: 0.2)
        case .home: return Color(red: 0.4, green: 0.8, blue: 0.4)
        case .games: return Color(red: 1.0, green: 0.6, blue: 0.0)
        case .sports: return Color(red: 0.3, green: 0.7, blue: 0.3)
        case .beauty: return Color(red: 0.8, green: 0.4, blue: 0.8)
        case .food: return Color(red: 0.9, green: 0.5, blue: 0.3)
        case .travel: return Color(red: 0.2, green: 0.8, blue: 0.9)
        case .experiences: return Color(red: 0.65, green: 0.3, blue: 0.8)
        case .hobbies: return Color(red: 0.5, green: 0.7, blue: 0.5)
        case .healthWellness: return Color(red: 0.9, green: 0.3, blue: 0.4)
        case .artCrafts: return Color(red: 0.7, green: 0.5, blue: 0.8)
        case .other: return Color.gray
        }
    }
}

struct GiftCreationData {
    var title: String = ""
    var description: String = ""
    var price: String = ""
    var currency: String = "USD"
    var category: GiftCategory = .other
    var tags: [String] = []
    var url: String = ""
    var imageURL: String = ""
    var contactId: String? = nil
    var eventId: String? = nil
    var notes: String = ""
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func toGift() -> Gift {
        let priceValue = Double(price.trimmingCharacters(in: .whitespacesAndNewlines))
        
        return Gift(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            price: priceValue,
            currency: currency,
            category: category,
            tags: tags.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
            url: url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : url.trimmingCharacters(in: .whitespacesAndNewlines),
            imageURL: imageURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : imageURL.trimmingCharacters(in: .whitespacesAndNewlines),
            contactId: contactId,
            eventId: eventId,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}

import SwiftUI
extension Color {
    init(red: Double, green: Double, blue: Double) {
        self.init(red: red, green: green, blue: blue, opacity: 1.0)
    }
}