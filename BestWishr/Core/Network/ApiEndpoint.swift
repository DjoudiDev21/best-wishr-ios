import Foundation

enum ApiEndpoint {
    case authLogin
    case authRegister
    case authVerifyEmail
    case authSendEmailVerification
    case authLogout
    case appleAuth
    case authSocialMobile
    
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
        case .appleAuth: return "auth/social/apple-signin"
        case .authSocialMobile: return "auth/social/mobile"
        }
    }

    private var method: String {
        switch self {
        case .authLogin, .authRegister, .authVerifyEmail, .authSendEmailVerification, .authLogout, .appleAuth, .authSocialMobile: return "POST"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
}
