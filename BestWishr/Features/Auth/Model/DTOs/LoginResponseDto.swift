import Foundation

struct LoginResponseDto: Decodable {
    let user: UserDto
    let accessToken: String
    let refreshToken: String?
}

struct UserDto: Decodable, Encodable {
    let id: String
    let email: String
    let firstname: String?
    let lastname: String?
}
