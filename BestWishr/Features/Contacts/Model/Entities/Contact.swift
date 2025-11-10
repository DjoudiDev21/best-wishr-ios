import Foundation
import SwiftUI

struct Contact: Identifiable, Codable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: Date?
    let category: ContactCategory
    let avatar: String?
    let createdAt: Date
    let updatedAt: Date
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        let firstInitial = firstName.prefix(1).uppercased()
        let lastInitial = lastName.prefix(1).uppercased()
        return "\(firstInitial)\(lastInitial)"
    }
}

enum ContactCategory: String, CaseIterable, Identifiable, Codable {
    case family = "Family"
    case friends = "Friends"
    case colleagues = "Colleagues"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .family: return "house.fill"
        case .friends: return "heart.fill"
        case .colleagues: return "briefcase.fill"
        case .other: return "person.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .family: return Color(red: 0.65, green: 0.3, blue: 0.8)
        case .friends: return Color(red: 0.75, green: 0.4, blue: 0.9)
        case .colleagues: return Color(red: 0.85, green: 0.5, blue: 0.7)
        case .other: return Color(red: 0.7, green: 0.35, blue: 0.75)
        }
    }
}

// MARK: - Contact Creation

struct ContactCreationData {
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: Date?
    let category: ContactCategory
    
    func toContact() -> Contact {
        let now = Date()
        return Contact(
            id: UUID().uuidString,
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            email: email?.trimmingCharacters(in: .whitespaces),
            phoneNumber: phoneNumber?.trimmingCharacters(in: .whitespaces),
            dateOfBirth: dateOfBirth,
            category: category,
            avatar: nil,
            createdAt: now,
            updatedAt: now
        )
    }
}