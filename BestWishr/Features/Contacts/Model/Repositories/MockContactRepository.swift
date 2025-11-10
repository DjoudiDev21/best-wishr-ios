import Foundation

final class MockContactRepository: ContactRepositoryProtocol {
    
    private var contacts: [Contact] = []
    
    init() {
        loadMockData()
    }
    
    func getContacts() async throws -> [Contact] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        return contacts.sorted { $0.firstName < $1.firstName }
    }
    
    func getContact(id: String) async throws -> Contact? {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return contacts.first { $0.id == id }
    }
    
    func createContact(_ contact: Contact) async throws -> Contact {
        try await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
        
        // Validate required fields
        guard !contact.firstName.isEmpty, !contact.lastName.isEmpty else {
            throw ContactError.invalidData("First name and last name are required")
        }
        
        // Check for duplicate email
        if let email = contact.email, !email.isEmpty {
            if contacts.contains(where: { $0.email?.lowercased() == email.lowercased() }) {
                throw ContactError.emailAlreadyExists
            }
        }
        
        contacts.append(contact)
        return contact
    }
    
    func updateContact(_ contact: Contact) async throws -> Contact {
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
        
        guard let index = contacts.firstIndex(where: { $0.id == contact.id }) else {
            throw ContactError.notFound
        }
        
        // Validate required fields
        guard !contact.firstName.isEmpty, !contact.lastName.isEmpty else {
            throw ContactError.invalidData("First name and last name are required")
        }
        
        let updatedContact = Contact(
            id: contact.id,
            firstName: contact.firstName,
            lastName: contact.lastName,
            email: contact.email,
            phoneNumber: contact.phoneNumber,
            dateOfBirth: contact.dateOfBirth,
            category: contact.category,
            avatar: contact.avatar,
            createdAt: contact.createdAt,
            updatedAt: Date()
        )
        
        contacts[index] = updatedContact
        return updatedContact
    }
    
    func deleteContact(id: String) async throws {
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4 seconds
        
        guard let index = contacts.firstIndex(where: { $0.id == id }) else {
            throw ContactError.notFound
        }
        
        contacts.remove(at: index)
    }
    
    func searchContacts(query: String) async throws -> [Contact] {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        let lowercasedQuery = query.lowercased()
        return contacts.filter { contact in
            contact.firstName.lowercased().contains(lowercasedQuery) ||
            contact.lastName.lowercased().contains(lowercasedQuery) ||
            contact.email?.lowercased().contains(lowercasedQuery) == true
        }.sorted { $0.firstName < $1.firstName }
    }
    
    func getContactsByCategory(_ category: ContactCategory) async throws -> [Contact] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return contacts.filter { $0.category == category }.sorted { $0.firstName < $1.firstName }
    }
    
    // MARK: - Private Methods
    
    private func loadMockData() {
        let now = Date()
        let calendar = Calendar.current
        
        contacts = [
            Contact(
                id: "1",
                firstName: "John",
                lastName: "Doe",
                email: "john.doe@example.com",
                phoneNumber: "+1234567890",
                dateOfBirth: calendar.date(byAdding: .year, value: -28, to: now),
                category: .friends,
                avatar: nil,
                createdAt: calendar.date(byAdding: .day, value: -30, to: now) ?? now,
                updatedAt: calendar.date(byAdding: .day, value: -5, to: now) ?? now
            ),
            Contact(
                id: "2",
                firstName: "Jane",
                lastName: "Smith",
                email: "jane.smith@example.com",
                phoneNumber: "+1987654321",
                dateOfBirth: calendar.date(byAdding: .year, value: -32, to: now),
                category: .family,
                avatar: nil,
                createdAt: calendar.date(byAdding: .day, value: -25, to: now) ?? now,
                updatedAt: calendar.date(byAdding: .day, value: -3, to: now) ?? now
            ),
            Contact(
                id: "3",
                firstName: "Mike",
                lastName: "Johnson",
                email: "mike.johnson@company.com",
                phoneNumber: "+1122334455",
                dateOfBirth: calendar.date(byAdding: .year, value: -35, to: now),
                category: .colleagues,
                avatar: nil,
                createdAt: calendar.date(byAdding: .day, value: -20, to: now) ?? now,
                updatedAt: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
            Contact(
                id: "4",
                firstName: "Sarah",
                lastName: "Wilson",
                email: "sarah.wilson@example.com",
                phoneNumber: nil,
                dateOfBirth: calendar.date(byAdding: .year, value: -29, to: now),
                category: .friends,
                avatar: nil,
                createdAt: calendar.date(byAdding: .day, value: -15, to: now) ?? now,
                updatedAt: calendar.date(byAdding: .day, value: -2, to: now) ?? now
            ),
            Contact(
                id: "5",
                firstName: "David",
                lastName: "Brown",
                email: "david.brown@family.com",
                phoneNumber: "+1555666777",
                dateOfBirth: calendar.date(byAdding: .year, value: -45, to: now),
                category: .family,
                avatar: nil,
                createdAt: calendar.date(byAdding: .day, value: -10, to: now) ?? now,
                updatedAt: now
            ),
            Contact(
                id: "6",
                firstName: "Emily",
                lastName: "Davis",
                email: "emily.davis@example.com",
                phoneNumber: "+1333222111",
                dateOfBirth: calendar.date(byAdding: .year, value: -26, to: now),
                category: .other,
                avatar: nil,
                createdAt: calendar.date(byAdding: .day, value: -8, to: now) ?? now,
                updatedAt: now
            )
        ]
    }
}

// MARK: - Contact Errors

enum ContactError: LocalizedError {
    case notFound
    case emailAlreadyExists
    case invalidData(String)
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Contact not found"
        case .emailAlreadyExists:
            return "A contact with this email already exists"
        case .invalidData(let message):
            return message
        case .networkError:
            return "Network connection error"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}