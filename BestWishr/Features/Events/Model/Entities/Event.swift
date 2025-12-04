import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String?
    let type: EventType
    let contactId: String?
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
        type: EventType,
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
        self.type = type
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
    var type: EventType = .birthday
    var contactId: String? = nil
    var date: Date = Date()
    var isRecurring: Bool = false
    var hasReminders: Bool = true
    var selectedReminderIntervals: Set<ReminderInterval> = []
    var giftSuggestionsEnabled: Bool = false
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var canGenerateGiftSuggestions: Bool {
        // Gift suggestions require at minimum an event type and date
        // Title is also recommended for better context
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Reminder Logic
    
    func availableReminderIntervals() -> [ReminderInterval] {
        let timeUntilEvent = date.timeIntervalSince(Date())
        let safetyBuffer: TimeInterval = 60 // 1 minute safety buffer
        
        return ReminderInterval.allCases.filter { interval in
            interval.timeInterval < timeUntilEvent - safetyBuffer
        }.sorted { $0.timeInterval > $1.timeInterval } // Largest intervals first
    }
    
    func isReminderIntervalAvailable(_ interval: ReminderInterval) -> Bool {
        return availableReminderIntervals().contains(interval)
    }
    
    func suggestedReminderIntervals() -> Set<ReminderInterval> {
        let available = Set(availableReminderIntervals())
        let defaults = Set(type.defaultReminders)
        return defaults.intersection(available)
    }
    
    func toEvent() -> Event {
        let recurrence = isRecurring ? RecurrenceRule(frequency: .yearly) : nil
        
        // Use user-selected reminders instead of automatic generation
        let reminders = hasReminders ? Array(selectedReminderIntervals).map { interval in
            EventReminder(interval: interval)
        } : []
        
        return Event(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            type: type,
            contactId: contactId,
            date: date,
            recurrence: recurrence,
            reminders: reminders
        )
    }
}

extension EventCreationData {
    init(title: String, type: EventType, contactId: String? = nil) {
        self.title = title
        self.type = type
        self.contactId = contactId
    }
}
