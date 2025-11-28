import Foundation
import SwiftUI

struct Contact: Identifiable, Codable, Equatable {
    let id: String
    let firstName: String
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: Date?
    let category: ContactCategory
    let description: String?
    let interests: [String]?
    let avatar: String?
    let createdAt: Date
    let updatedAt: Date
    
    var fullName: String {
        "\(firstName) \(lastName ?? "")"
    }
    
    var initials: String {
        let firstInitial = firstName.prefix(1).uppercased()
        let lastInitial = lastName?.prefix(1).uppercased()
        return "\(firstInitial)\(lastInitial ?? "")"
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
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var phoneCountry: Country = Country.default
    var dateOfBirth: Date? = nil
    var category: ContactCategory = .family
    var description: String = ""
    var interests: [String] = []
    var hasBirthday: Bool = false
    
    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func toContact() -> Contact {
        let now = Date()
        
        // Format phone number with selected country
        let formattedPhoneNumber = PhoneNumberValidator.validateAndFormat(
            phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            country: phoneCountry
        )
        
        return Contact(
            id: UUID().uuidString,
            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : email.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: formattedPhoneNumber,
            dateOfBirth: hasBirthday ? dateOfBirth : nil,
            category: category,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            interests: interests.isEmpty ? nil : interests,
            avatar: nil,
            createdAt: now,
            updatedAt: now
        )
    }
}
