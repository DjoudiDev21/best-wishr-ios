import Foundation

struct SocialAuthResponseDto: Codable {
    let accessToken: String
    let refreshToken: String
    let user: UserDto
    let isNewUser: Bool
    let linkedAccounts: [SocialAccount]
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
        case user
        case isNewUser = "isNewUser"
        case linkedAccounts = "linkedAccounts"
    }
}

struct SocialAccount: Codable {
    let provider: String
    let providerId: String
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case provider
        case providerId = "providerId"
        case email
    }
}
