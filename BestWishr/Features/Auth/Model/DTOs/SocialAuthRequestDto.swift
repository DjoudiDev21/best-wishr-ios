import Foundation

struct SocialAuthRequestDto: Codable {
    let provider: String
    let accessToken: String?
    let authorizationCode: String?
    let platform: String
    let redirectUri: String?
    
    enum CodingKeys: String, CodingKey {
        case provider
        case accessToken = "accessToken"
        case authorizationCode = "authorizationCode"
        case platform
        case redirectUri = "redirectUri"
    }
}