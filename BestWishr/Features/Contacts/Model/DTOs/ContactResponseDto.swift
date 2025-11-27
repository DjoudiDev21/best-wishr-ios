import Foundation

struct ContactResponseDto: Decodable {
    let id: String
    let ownerId: String
    let firstName: String
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: String?
    let category: String
    let description: String?
    let interests: [String]
    let avatar: String?
    let createdAt: String
    let updatedAt: String
}

extension ContactResponseDto {
    func toEntity() -> Contact {
        let formatter = ISO8601DateFormatter()
        
        return Contact(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth.flatMap { formatter.date(from: $0) },
            category: ContactCategory(rawValue: category) ?? .other,
            description: description,
            interests: interests,
            avatar: avatar,
            createdAt: formatter.date(from: createdAt) ?? Date(),
            updatedAt: formatter.date(from: updatedAt) ?? Date()
        )
    }
}
