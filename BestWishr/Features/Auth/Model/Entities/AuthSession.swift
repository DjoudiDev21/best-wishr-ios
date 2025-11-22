import Foundation

struct AuthSession {
    let user: User
    let tokens: AuthTokens
    
    init(user: User, tokens: AuthTokens) {
        self.user = user
        self.tokens = tokens
    }
    
    var isValid: Bool {
        return !tokens.isExpired
    }
}