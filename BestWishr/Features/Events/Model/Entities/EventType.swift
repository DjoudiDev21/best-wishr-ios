import Foundation
import SwiftUI

enum EventType: String, CaseIterable, Identifiable, Codable {
    case birthday = "Birthday"
    case anniversary = "Anniversary"
    case wedding = "Wedding"
    case graduation = "Graduation"
    case holiday = "Holiday"
    case meeting = "Meeting"
    case celebration = "Celebration"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .birthday:
            return "birthday.cake"
        case .anniversary:
            return "heart.circle"
        case .wedding:
            return "heart"
        case .graduation:
            return "graduationcap"
        case .holiday:
            return "sun.max"
        case .meeting:
            return "person.2"
        case .celebration:
            return "party.popper"
        case .other:
            return "calendar"
        }
    }
    
    var color: Color {
        switch self {
        case .birthday:
            return Color(red: 1.0, green: 0.6, blue: 0.8) // Pink
        case .anniversary:
            return Color(red: 0.8, green: 0.2, blue: 0.4) // Deep red
        case .wedding:
            return Color(red: 0.9, green: 0.7, blue: 0.9) // Light purple
        case .graduation:
            return Color(red: 0.2, green: 0.6, blue: 0.9) // Blue
        case .holiday:
            return Color(red: 1.0, green: 0.8, blue: 0.2) // Gold
        case .meeting:
            return Color(red: 0.5, green: 0.7, blue: 0.9) // Light blue
        case .celebration:
            return Color(red: 0.6, green: 0.9, blue: 0.4) // Green
        case .other:
            return Color(red: 0.7, green: 0.7, blue: 0.7) // Gray
        }
    }
    
    var description: String {
        switch self {
        case .birthday:
            return "Celebrate someone's special day"
        case .anniversary:
            return "Mark important milestones and memories"
        case .wedding:
            return "Celebrate the union of two people"
        case .graduation:
            return "Honor academic achievements"
        case .holiday:
            return "Seasonal and cultural celebrations"
        case .meeting:
            return "Professional and personal meetings"
        case .celebration:
            return "General celebrations and parties"
        case .other:
            return "Other important events"
        }
    }
    
    var defaultReminders: [ReminderInterval] {
        switch self {
        case .birthday, .anniversary:
            return [.oneWeek, .threeDays, .oneDay]
        case .wedding, .graduation:
            return [.oneMonth, .oneWeek, .oneDay]
        case .holiday:
            return [.oneWeek, .oneDay]
        case .meeting:
            return [.oneHour, .fifteenMinutes]
        case .celebration:
            return [.threeDays, .oneDay]
        case .other:
            return [.oneDay]
        }
    }
}

enum ReminderInterval: String, CaseIterable, Identifiable, Codable {
    case oneMonth = "1 Month"
    case oneWeek = "1 Week"
    case threeDays = "3 Days"
    case oneDay = "1 Day"
    case twelveHours = "12 Hours"
    case sixHours = "6 Hours"
    case threeHours = "3 Hours"
    case oneHour = "1 Hour"
    case thirtyMinutes = "30 Minutes"
    case fifteenMinutes = "15 Minutes"
    
    var id: String { rawValue }
    
    var timeInterval: TimeInterval {
        switch self {
        case .oneMonth:
            return 30 * 24 * 60 * 60 // 30 days
        case .oneWeek:
            return 7 * 24 * 60 * 60 // 7 days
        case .threeDays:
            return 3 * 24 * 60 * 60 // 3 days
        case .oneDay:
            return 24 * 60 * 60 // 1 day
        case .twelveHours:
            return 12 * 60 * 60 // 12 hours
        case .sixHours:
            return 6 * 60 * 60 // 6 hours
        case .threeHours:
            return 3 * 60 * 60 // 3 hours
        case .oneHour:
            return 60 * 60 // 1 hour
        case .thirtyMinutes:
            return 30 * 60 // 30 minutes
        case .fifteenMinutes:
            return 15 * 60 // 15 minutes
        }
    }
    
    var shortDescription: String {
        switch self {
        case .oneMonth: return "1M"
        case .oneWeek: return "1W"
        case .threeDays: return "3D"
        case .oneDay: return "1D"
        case .twelveHours: return "12H"
        case .sixHours: return "6H"
        case .threeHours: return "3H"
        case .oneHour: return "1H"
        case .thirtyMinutes: return "30M"
        case .fifteenMinutes: return "15M"
        }
    }
}