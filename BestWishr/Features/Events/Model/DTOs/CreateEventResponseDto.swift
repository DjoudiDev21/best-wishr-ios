import Foundation

struct CreateEventResponseDto: Decodable {
    let id: String
    let title: String
    let description: String?
    let type: EventType
    let contactId: String?
    let date: String
    let isCompleted: Bool
    let createdAt: String
    let updatedAt: String
}

// MARK: - Event Extensions

extension CreateEventResponseDto {
    func toEntity() -> Event {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return Event(
            id: id,
            title: title,
            description: description,
            type: type,
            contactId: contactId,
            date: formatter.date(from: date) ?? Date(),
            recurrence: nil, // Backend doesn't handle recurrence yet
            reminders: [], // Backend doesn't return reminders yet
            isCompleted: isCompleted,
            createdAt: formatter.date(from: createdAt) ?? Date(),
            updatedAt: formatter.date(from: updatedAt) ?? Date()
        )
    }
}
