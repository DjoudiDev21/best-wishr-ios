import Foundation

struct RecurrenceRule: Codable, Hashable {
    let frequency: RecurrenceFrequency
    let interval: Int
    let endDate: Date?
    
    init(
        frequency: RecurrenceFrequency,
        interval: Int = 1,
        endDate: Date? = nil
    ) {
        self.frequency = frequency
        self.interval = interval
        self.endDate = endDate
    }
    
    var description: String {
        let frequencyText: String
        switch frequency {
        case .daily:
            frequencyText = interval == 1 ? "Daily" : "Every \(interval) days"
        case .weekly:
            frequencyText = interval == 1 ? "Weekly" : "Every \(interval) weeks"
        case .monthly:
            frequencyText = interval == 1 ? "Monthly" : "Every \(interval) months"
        case .yearly:
            frequencyText = interval == 1 ? "Yearly" : "Every \(interval) years"
        }
        
        if let endDate = endDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "\(frequencyText) until \(formatter.string(from: endDate))"
        } else {
            return frequencyText
        }
    }
    
    func nextOccurrence(after date: Date) -> Date? {
        let calendar = Calendar.current
        switch frequency {
        case .daily:
            return calendar.date(byAdding: .day, value: interval, to: date)
        case .weekly:
            return calendar.date(byAdding: .weekOfYear, value: interval, to: date)
        case .monthly:
            return calendar.date(byAdding: .month, value: interval, to: date)
        case .yearly:
            return calendar.date(byAdding: .year, value: interval, to: date)
        }
    }
    
    func allOccurrences(startingFrom startDate: Date, until endDate: Date) -> [Date] {
        var occurrences: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            occurrences.append(currentDate)
            guard let nextDate = nextOccurrence(after: currentDate) else { break }
            currentDate = nextDate
            
            // Respect the rule's end date if set
            if let ruleEndDate = self.endDate, currentDate > ruleEndDate {
                break
            }
        }
        
        return occurrences
    }
}

enum RecurrenceFrequency: String, CaseIterable, Identifiable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .daily:
            return "sun.max"
        case .weekly:
            return "calendar.circle"
        case .monthly:
            return "calendar"
        case .yearly:
            return "calendar.badge.plus"
        }
    }
    
    var description: String {
        switch self {
        case .daily:
            return "Repeats every day"
        case .weekly:
            return "Repeats every week"
        case .monthly:
            return "Repeats every month"
        case .yearly:
            return "Repeats every year"
        }
    }
}