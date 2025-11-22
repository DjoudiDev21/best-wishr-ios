import Foundation

struct SendEmailVerificationDto: Encodable {
    let email: String
}

struct ResendVerificationResponseDto: Decodable {
    let message: String
}