import Foundation

enum ApiEndpoint {
    case authLogin
    case authRegister
    
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
        }
    }

    private var method: String {
        switch self {
        case .authLogin, .authRegister: return "POST"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
}
