import Foundation

// MARK: - Contact DTOs

struct ContactResponseDto: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: String?
    let category: String
    let avatar: String?
    let createdAt: String
    let updatedAt: String
}

struct ContactRequestDto: Encodable {
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: String?
    let category: String
}

// MARK: - Contact Filters

struct ContactFilters {
    let searchText: String?
    let category: ContactCategory?
    let hasUpcomingEvents: Bool?
    
    static let empty = ContactFilters(
        searchText: nil,
        category: nil,
        hasUpcomingEvents: nil
    )
}

// MARK: - Contact Sorting

enum ContactSortOption: String, CaseIterable {
    case firstName = "firstName"
    case lastName = "lastName"
    case dateAdded = "dateAdded"
    case category = "category"
    
    var displayName: String {
        switch self {
        case .firstName: return "First Name"
        case .lastName: return "Last Name"
        case .dateAdded: return "Date Added"
        case .category: return "Category"
        }
    }
}
