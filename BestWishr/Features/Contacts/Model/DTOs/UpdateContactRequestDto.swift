import Foundation

struct UpdateContactRequestDto: Encodable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: String?
    let category: String?
    let description: String?
    let interests: [String]?
}

// MARK: - Contact Extensions

extension Contact {
    func toUpdateRequestDto() -> UpdateContactRequestDto {
        let formatter = ISO8601DateFormatter()
        
        return UpdateContactRequestDto(
            firstName: firstName.isEmpty ? nil : firstName,
            lastName: lastName?.isEmpty == false ? lastName : nil,
            email: email?.isEmpty == false ? email : nil,
            phoneNumber: phoneNumber?.isEmpty == false ? phoneNumber : nil,
            dateOfBirth: dateOfBirth.map { formatter.string(from: $0) },
            category: category.rawValue,
            description: description?.isEmpty == false ? description : nil,
            interests: interests?.isEmpty == false ? interests : nil
        )
    }
}
