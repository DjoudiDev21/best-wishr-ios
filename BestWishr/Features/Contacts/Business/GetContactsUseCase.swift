import Foundation

struct GetContactsUseCase {
    private let repository: ContactRepositoryProtocol
    
    init(repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(filters: ContactFilters? = nil, sortBy: ContactSortOption = .firstName) async -> Result<[Contact], Error> {
        do {
            var contacts: [Contact]
            
            // Apply filters
            if let searchText = filters?.searchText, !searchText.isEmpty {
                contacts = try await repository.searchContacts(query: searchText)
            } else if let category = filters?.category {
                contacts = try await repository.getContactsByCategory(category)
            } else {
                contacts = try await repository.getContacts()
            }
            
            // Apply sorting
            contacts = sortContacts(contacts, by: sortBy)
            
            return .success(contacts)
        } catch {
            return .failure(error)
        }
    }
    
    private func sortContacts(_ contacts: [Contact], by sortOption: ContactSortOption) -> [Contact] {
        switch sortOption {
        case .firstName:
            return contacts.sorted { $0.firstName < $1.firstName }
        case .lastName:
            return contacts.sorted { $0.lastName < $1.lastName }
        case .dateAdded:
            return contacts.sorted { $0.createdAt > $1.createdAt }
        case .category:
            return contacts.sorted { $0.category.rawValue < $1.category.rawValue }
        }
    }
}
