import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String?
    let eventType: EventType
    let contactId: String? // Links to contact if event is for someone
    let date: Date
    let recurrence: RecurrenceRule?
    let reminders: [EventReminder]
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String? = nil,
        eventType: EventType,
        contactId: String? = nil,
        date: Date,
        recurrence: RecurrenceRule? = nil,
        reminders: [EventReminder] = [],
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.eventType = eventType
        self.contactId = contactId
        self.date = date
        self.recurrence = recurrence
        self.reminders = reminders
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // Computed properties
    var isUpcoming: Bool {
        date > Date()
    }
    
    var isPast: Bool {
        date < Date()
    }
    
    var isToday: Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
    
    var daysUntilEvent: Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let eventDay = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: now, to: eventDay).day ?? 0
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var shortFormattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Event Creation Data
struct EventCreationData {
    var title: String = ""
    var description: String = ""
    var eventType: EventType = .birthday
    var contactId: String? = nil
    var date: Date = Date()
    var isRecurring: Bool = false
    var hasReminders: Bool = true
    var giftSuggestionsEnabled: Bool = false
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func toEvent() -> Event {
        let recurrence = isRecurring ? RecurrenceRule(frequency: .yearly) : nil
        let reminders = hasReminders ? eventType.defaultReminders : []
        
        return Event(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            eventType: eventType,
            contactId: contactId,
            date: date,
            recurrence: recurrence,
            reminders: reminders as! [EventReminder]
        )
    }
}

extension EventCreationData {
    init(title: String, eventType: EventType, contactId: String? = nil) {
        self.title = title
        self.eventType = eventType
        self.contactId = contactId
    }
}
