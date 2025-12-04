import Foundation

struct EventReminder: Identifiable, Codable, Hashable {
    let id: String
    let interval: ReminderInterval
    let isEnabled: Bool
    
    init(
        id: String = UUID().uuidString,
        interval: ReminderInterval,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.interval = interval
        self.isEnabled = isEnabled
    }
    
    func reminderDate(for eventDate: Date) -> Date {
        return eventDate.addingTimeInterval(-interval.timeInterval)
    }
    
    var description: String {
        return "Remind me \(interval.rawValue.lowercased()) before"
    }
}

// MARK: - Event Filters and Sorting
enum EventFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case upcoming = "Upcoming"
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case completed = "Completed"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .all:
            return "calendar"
        case .upcoming:
            return "clock"
        case .today:
            return "sun.max"
        case .thisWeek:
            return "calendar.circle"
        case .thisMonth:
            return "calendar.badge.clock"
        case .completed:
            return "checkmark.circle"
        }
    }
    
    func matches(event: Event) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .all:
            return true
        case .upcoming:
            return event.isUpcoming && !event.isCompleted
        case .today:
            return calendar.isDate(event.date, inSameDayAs: now)
        case .thisWeek:
            return calendar.isDate(event.date, equalTo: now, toGranularity: .weekOfYear)
        case .thisMonth:
            return calendar.isDate(event.date, equalTo: now, toGranularity: .month)
        case .completed:
            return event.isCompleted
        }
    }
}

enum EventSortOption: String, CaseIterable, Identifiable {
    case date = "Date"
    case title = "Title"
    case type = "Event Type"
    case dateCreated = "Date Created"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .date:
            return "calendar"
        case .title:
            return "textformat.abc"
        case .type:
            return "tag"
        case .dateCreated:
            return "clock"
        }
    }
    
    func sort(_ events: [Event]) -> [Event] {
        switch self {
        case .date:
            return events.sorted { $0.date < $1.date }
        case .title:
            return events.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .type:
            return events.sorted { $0.type.rawValue.localizedCaseInsensitiveCompare($1.type.rawValue) == .orderedAscending }
        case .dateCreated:
            return events.sorted { $0.createdAt > $1.createdAt }
        }
    }
}
