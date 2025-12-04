import Foundation

enum ApiEndpoint {
    case authLogin
    case authRegister
    case authVerifyEmail
    case authSendEmailVerification
    case authLogout
    case authForgotPassword
    case authResetPassword
    case appleAuth
    case authSocialMobile
    case listContacts(ownerId: String)
    case createContact
    case updateContact(String)
    case listEvents(ownerId: String)
    case createEvent
    case updateEvent(String)
    case deleteEvent(String)
    case listGifts
    case createGift
    case updateGift(String)
    case deleteGift(String)
    case generateGiftSuggestions
    case getGiftSuggestions(eventId: String?, contactId: String?, category: String?, isBookmarked: Bool?, isPurchased: Bool?, limit: Int?, offset: Int?)
    case getBookmarkedSuggestions
    case getSuggestionsByEvent(String)
    case getSuggestionsByContact(String)
    case rateSuggestion
    case updateSuggestion
    case bookmarkSuggestion(String)
    case unbookmarkSuggestion(String)
    case removeFromWishlist(String)
    
    var requiresAuth: Bool {
        switch self {
        case .authLogin, .authRegister:
            return false
        default:
            return true
        }
    }
    
    func makeRequest(baseURL: URL) throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        if let queryItems = queryItems {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            url = components?.url ?? url
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }

    private var path: String {
        switch self {
        case .authLogin: return "auth/login"
        case .authRegister: return "auth/register"
        case .authVerifyEmail: return "auth/verify-email"
        case .authSendEmailVerification: return "auth/send-email-verification"
        case .authLogout: return "auth/logout/mobile"
        case .authForgotPassword: return "auth/forgot-password"
        case .authResetPassword: return "auth/reset-password"
        case .appleAuth: return "auth/social/apple-signin"
        case .authSocialMobile: return "auth/social/mobile"
        case .listContacts: return "contacts"
        case .createContact: return "contacts"
        case .updateContact(let id): return "contacts/\(id)"
        case .listEvents: return "events"
        case .createEvent: return "events"
        case .updateEvent(let id): return "events/\(id)"
        case .deleteEvent(let id): return "events/\(id)"
        case .listGifts: return "gifts"
        case .createGift: return "gifts"
        case .updateGift(let id): return "gifts/\(id)"
        case .deleteGift(let id): return "gifts/\(id)"
        case .generateGiftSuggestions: return "gift-suggestions/generate"
        case .getGiftSuggestions: return "gift-suggestions"
        case .getBookmarkedSuggestions: return "gift-suggestions/bookmarked"
        case .getSuggestionsByEvent(let eventId): return "gift-suggestions/events/\(eventId)"
        case .getSuggestionsByContact(let contactId): return "gift-suggestions/contacts/\(contactId)"
        case .rateSuggestion: return "gift-suggestions/rate"
        case .updateSuggestion: return "gift-suggestions/update"
        case .bookmarkSuggestion(let suggestionId): return "gift-suggestions/\(suggestionId)/bookmark"
        case .unbookmarkSuggestion(let suggestionId): return "gift-suggestions/\(suggestionId)/unbookmark"
        case .removeFromWishlist(let id): return "gifts/wishlist/\(id)"
        }
    }

    private var method: String {
        switch self {
        case .authLogin, .authRegister, .authVerifyEmail, .authSendEmailVerification, .authLogout, .authForgotPassword, .authResetPassword, .appleAuth, .authSocialMobile, .createContact, .createEvent, .createGift, .generateGiftSuggestions, .rateSuggestion:
            return "POST"
        case .listContacts, .listEvents, .listGifts, .getGiftSuggestions, .getBookmarkedSuggestions, .getSuggestionsByEvent, .getSuggestionsByContact:
            return "GET"
        case .updateContact, .updateEvent, .updateGift, .updateSuggestion, .bookmarkSuggestion, .unbookmarkSuggestion:
            return "PATCH"
        case .deleteEvent, .deleteGift, .removeFromWishlist:
            return "DELETE"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .listContacts(let ownerId), .listEvents(let ownerId):
            return [URLQueryItem(name: "ownerId", value: ownerId)]
        case .getGiftSuggestions(let eventId, let contactId, let category, let isBookmarked, let isPurchased, let limit, let offset):
            var items: [URLQueryItem] = []
            if let eventId = eventId { items.append(URLQueryItem(name: "eventId", value: eventId)) }
            if let contactId = contactId { items.append(URLQueryItem(name: "contactId", value: contactId)) }
            if let category = category { items.append(URLQueryItem(name: "category", value: category)) }
            if let isBookmarked = isBookmarked { items.append(URLQueryItem(name: "isBookmarked", value: String(isBookmarked))) }
            if let isPurchased = isPurchased { items.append(URLQueryItem(name: "isPurchased", value: String(isPurchased))) }
            if let limit = limit { items.append(URLQueryItem(name: "limit", value: String(limit))) }
            if let offset = offset { items.append(URLQueryItem(name: "offset", value: String(offset))) }
            return items.isEmpty ? nil : items
        default:
            return nil
        }
    }
}
