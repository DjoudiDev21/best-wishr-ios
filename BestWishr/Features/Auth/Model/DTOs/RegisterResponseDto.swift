import Foundation

struct RegisterResponseDto: Decodable {
    let id: String
    let email: String
    let token: String
    let firstName: String?
    let lastName: String?
}