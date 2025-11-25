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
    @Published var shouldShowResetPassword: Bool = false
    @Published var resetPasswordToken: String = ""
    @Published var resetPasswordEmail: String = ""
    
    func handleURL(url: URL) -> Bool {
        // Handle both custom scheme and Universal Links
        let isCustomScheme = url.scheme == "bestwishr"
        let isUniversalLink = url.scheme == "https" && (url.host == "bestwishr.com" || url.host == "api.bestwishr.com")
        
        guard isCustomScheme || isUniversalLink else { return false }
        
        let path = isCustomScheme ? (url.host ?? "") : url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        switch path {
        case "verify-email":
            if let token = components?.queryItems?.first(where: { $0.name == "token" })?.value {
                let email = components?.queryItems?.first(where: { $0.name == "email" })?.value ?? ""
                activeDestination = .verifyEmail(token: token, email: email)
                return true
            }
            
        case "reset-password":
            print("🔗 URLManager: Processing reset-password case")
            print("🔗 URLManager: Query items: \(components?.queryItems ?? [])")
            
            if let token = components?.queryItems?.first(where: { $0.name == "token" })?.value {
                let email = components?.queryItems?.first(where: { $0.name == "email" })?.value ?? ""
                print("🔗 URLManager: Parsed reset-password URL - token: \(token.prefix(10))..., email: '\(email)'")
                activeDestination = .resetPassword(token: token, email: email)
                print("🔗 URLManager: Set activeDestination to resetPassword")
                return true
            } else {
                print("❌ URLManager: No token found in query items")
                return false
            }
            
        default:
            return false
        }
        
        return false
    }
    
    func clearActiveDestination() {
        activeDestination = nil
        shouldShowResetPassword = false
        resetPasswordToken = ""
        resetPasswordEmail = ""
    }
    
    func setResetPasswordMode(_ shouldShow: Bool) {
        print("🔗 URLManager: Setting reset password mode to \(shouldShow)")
        shouldShowResetPassword = shouldShow
        
        // Store reset password data when showing the modal
        if shouldShow, case let .resetPassword(token, email) = activeDestination {
            resetPasswordToken = token
            resetPasswordEmail = email
            print("🔗 URLManager: Stored reset password data - token: \(token.prefix(10))..., email: \(email)")
        }
        
        print("🔗 URLManager: shouldShowResetPassword is now \(shouldShowResetPassword)")
    }
    
    func setProcessingState(_ isProcessing: Bool) {
        isProcessingURL = isProcessing
    }
}
