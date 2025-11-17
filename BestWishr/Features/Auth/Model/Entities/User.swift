import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    let email: String
    let token: String
    let firstname: String?
    let lastname: String?
}
