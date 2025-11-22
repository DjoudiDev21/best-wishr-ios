import Foundation

struct VerifyEmailResponseDto: Decodable {
    let user: UserDto
    let accessToken: String
    let refreshToken: String?
}