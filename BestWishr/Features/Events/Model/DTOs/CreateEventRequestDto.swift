import Foundation

struct CreateEventRequestDto: Encodable {
    let ownerId: String
    let title: String
    let description: String?
    let type: String
    let contactId: String?
    let date: String
}

// MARK: - Event Extensions

extension Event {
    func toCreateRequestDto(ownerId: String) -> CreateEventRequestDto {
        let formatter = ISO8601DateFormatter()
        
        return CreateEventRequestDto(
            ownerId: ownerId,
            title: title,
            description: description?.isEmpty == false ? description : nil,
            type: type.rawValue,
            contactId: contactId,
            date: formatter.string(from: date)
        )
    }
}
