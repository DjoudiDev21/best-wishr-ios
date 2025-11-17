import Foundation
import SwiftUI
import Combine

enum URLDestination {
    case verifyEmail(token: String, email: String)
    case resetPassword(token: String, email: String)
}

class URLManager: ObservableObject {
    @Published var activeDestination: URLDestination?
    @Published var isProcessingURL: Bool = false
    
    func handleURL(url: URL) -> Bool {
        // Handle both custom scheme and Universal Links
        let isCustomScheme = url.scheme == "bestwishr"
        let isUniversalLink = url.scheme == "https" && url.host == "bestwishr.com"
        
        guard isCustomScheme || isUniversalLink else { return false }
        
        let path = isCustomScheme ? (url.host ?? "") : url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        switch path {
        case "verify-email":
            if let token = components?.queryItems?.first(where: { $0.name == "token" })?.value,
               let email = components?.queryItems?.first(where: { $0.name == "email" })?.value {
                activeDestination = .verifyEmail(token: token, email: email)
                return true
            }
            
        case "reset-password":
            if let token = components?.queryItems?.first(where: { $0.name == "token" })?.value,
               let email = components?.queryItems?.first(where: { $0.name == "email" })?.value {
                activeDestination = .resetPassword(token: token, email: email)
                return true
            }
            
        default:
            return false
        }
        
        return false
    }
    
    func clearActiveDestination() {
        activeDestination = nil
    }
    
    func setProcessingState(_ isProcessing: Bool) {
        isProcessingURL = isProcessing
    }
}