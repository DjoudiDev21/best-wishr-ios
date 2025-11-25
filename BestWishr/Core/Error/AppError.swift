import Foundation

enum BannerErrorType: String, CaseIterable {
    case emailVerification = "emailVerification"
    case forgotPassword = "forgotPassword"
    case loginUnverified = "loginUnverified"
    case verificationExpired = "verificationExpired"
}

enum AppError: Error {
    case network(String)
    case authentication(String)
    case validation(String)
    case unknown(String)
    case server(Int, String)
    case noInternet
    case timeout
    case decodingError(String)
    
    var localizedDescription: String {
        switch self {
        case .network(let message):
            return "Network error: \(message)"
        case .authentication(let message):
            return "Authentication error: \(message)"
        case .validation(let message):
            return "Validation error: \(message)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        case .server(let code, let message):
            return "Server error (\(code)): \(message)"
        case .noInternet:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .decodingError(let message):
            return "Data parsing error: \(message)"
        }
    }
    
    var userFriendlyMessage: String {
        switch self {
        case .network:
            return "Please check your internet connection and try again."
        case .authentication:
            return "Please check your credentials and try again."
        case .validation(let message):
            return message
        case .unknown:
            return "Something went wrong. Please try again."
        case .server(let code, _):
            if code >= 500 {
                return "Server is temporarily unavailable. Please try again later."
            } else {
                return "Request failed. Please try again."
            }
        case .noInternet:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "Request timed out. Please try again."
        case .decodingError:
            return "Unable to process server response. Please try again."
        }
    }
    
    var shouldRetry: Bool {
        switch self {
        case .network, .noInternet, .timeout:
            return true
        case .server(let code, _):
            return code >= 500
        default:
            return false
        }
    }
}