import Foundation

struct LoginRequestDto: Encodable {
    let email: String
    let password: String
}
