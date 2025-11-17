import Foundation

struct LoginResponseDto: Decodable {
    let id: String
    let email: String
    let token: String
    let firstname: String?
    let lastname: String?
}
