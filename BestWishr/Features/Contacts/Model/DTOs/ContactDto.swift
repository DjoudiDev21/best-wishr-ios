import Foundation

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
