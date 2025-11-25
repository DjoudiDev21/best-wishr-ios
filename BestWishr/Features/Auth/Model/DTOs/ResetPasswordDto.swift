import Foundation

struct ResetPasswordDto: Encodable {
    let token: String
    let newPassword: String
}