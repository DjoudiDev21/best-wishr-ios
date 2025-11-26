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
    case listEvents(ownerId: String)
    case createEvent
    case updateEvent(String)
    case deleteEvent(String)
    case listGifts
    case createGift
    case updateGift(String)
    case deleteGift(String)
    case generateGiftSuggestions
    case saveToWishlist
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
        case .listEvents: return "events"
        case .createEvent: return "events"
        case .updateEvent(let id): return "events/\(id)"
        case .deleteEvent(let id): return "events/\(id)"
        case .listGifts: return "gifts"
        case .createGift: return "gifts"
        case .updateGift(let id): return "gifts/\(id)"
        case .deleteGift(let id): return "gifts/\(id)"
        case .generateGiftSuggestions: return "gifts/suggestions"
        case .saveToWishlist: return "gifts/wishlist"
        case .removeFromWishlist(let id): return "gifts/wishlist/\(id)"
        }
    }

    private var method: String {
        switch self {
        case .authLogin, .authRegister, .authVerifyEmail, .authSendEmailVerification, .authLogout, .authForgotPassword, .authResetPassword, .appleAuth, .authSocialMobile, .createContact, .createEvent, .createGift, .generateGiftSuggestions, .saveToWishlist:
            return "POST"
        case .listContacts, .listEvents, .listGifts:
            return "GET"
        case .updateEvent, .updateGift:
            return "PUT"
        case .deleteEvent, .deleteGift, .removeFromWishlist:
            return "DELETE"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .listContacts(let ownerId), .listEvents(let ownerId):
            return [URLQueryItem(name: "ownerId", value: ownerId)]
        default:
            return nil
        }
    }
}
