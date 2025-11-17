import Foundation

struct RegisterRequestDto: Encodable {
    let email: String
    let password: String
    let firstname: String
    let lastname: String
}
