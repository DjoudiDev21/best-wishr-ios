import Foundation

struct CreateContactRequestDto: Encodable {
    let ownerId: String
    let firstName: String
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: String?
    let category: String
    let description: String?
    let interests: [String]
}

// MARK: - Contact Extensions

extension Contact {
    func toRequestDto(ownerId: String) -> CreateContactRequestDto {
        let formatter = ISO8601DateFormatter()
        
        return CreateContactRequestDto(
            ownerId: ownerId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth.map { formatter.string(from: $0) },
            category: category.rawValue,
            description: description,
            interests: interests ?? []
        )
    }
}
