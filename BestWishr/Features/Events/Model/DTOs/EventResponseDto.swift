import Foundation

struct EventResponseDto: Codable {
    let id: String
    let title: String
    let description: String?
    let type: EventType
    let contactId: String?
    let date: String
    let recurrence: String
    let reminders: [EventReminder]
    let isCompleted: Bool
    let createdAt: String
    let updatedAt: String
}

// MARK: - EventResponseDto Extensions

extension EventResponseDto {
    func toEntity() -> Event {
        let formatter = ISO8601DateFormatter()
        
        return Event(
            id: id,
            title: title,
            description: description,
            type: EventType(rawValue: type.rawValue) ?? .other,
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
