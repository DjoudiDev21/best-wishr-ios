import Foundation

struct AppleAuthRequestDto: Codable {
    let userIdentifier: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let identityToken: String
    let authorizationCode: String
    
    enum CodingKeys: String, CodingKey {
        case userIdentifier = "user_identifier"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case identityToken = "identity_token"
        case authorizationCode = "authorization_code"
    }
}
