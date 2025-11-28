import Foundation

final class HttpContactRepository: ContactRepositoryProtocol {
    private let httpClient: HttpClientProtocol
    private let userIdProvider: () -> String?
    private var contacts: [Contact] = []
    
    init(httpClient: HttpClientProtocol, userIdProvider: @escaping () -> String?) {
        self.httpClient = httpClient
        self.userIdProvider = userIdProvider
    }
    
    func getContacts() async throws -> [Contact] {
        print("🏪 HttpContactRepository: Getting contacts...")
        
        guard let ownerId = userIdProvider() else {
            print("❌ HttpContactRepository: No user ID available")
            throw ContactError.invalidData("User ID not available")
        }
        
        print("🏪 HttpContactRepository: Using owner ID: \(ownerId)")
        
        do {
            let contactDtos: [ContactResponseDto] = try await httpClient.get(.listContacts(ownerId: ownerId))
            print("✅ HttpContactRepository: Successfully retrieved \(contactDtos.count) contact DTOs")
            let contacts = contactDtos.map { $0.toEntity() }
            print("✅ HttpContactRepository: Converted to \(contacts.count) contacts")
            return contacts.sorted { $0.firstName < $1.firstName }
        } catch {
            print("❌ HttpContactRepository: Failed to get contacts - \(error)")
            throw error
        }
    }
    
    func getContact(id: String) async throws -> Contact? {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return contacts.first { $0.id == id }
    }
    
    func createContact(_ contact: Contact) async throws -> Contact {
        print("🌐 HttpContactRepository: Starting contact creation")
        print("🌐 HttpContactRepository: Contact - ID: \(contact.id), firstName: \(contact.firstName), lastName: \(contact.lastName ?? "")")
        
        guard let ownerId = userIdProvider() else {
            print("❌ HttpContactRepository: No user ID available for contact creation")
            throw ContactError.invalidData("User ID not available")
        }
        
        do {
            let body = contact.toRequestDto(ownerId: ownerId)
            print("🌐 HttpContactRepository: Converted to DTO, making HTTP POST request")
            
            let responseDto: ContactResponseDto = try await httpClient.post(.createContact, body: body)
            print("✅ HttpContactRepository: HTTP request succeeded")
            print("🌐 HttpContactRepository: Response DTO - ID: \(responseDto.id), firstName: \(responseDto.firstName)")
            
            let savedContact = responseDto.toEntity()
            print("✅ HttpContactRepository: Contact creation completed - Final ID: \(savedContact.id)")
            return savedContact
        } catch {
            print("❌ HttpContactRepository: Contact creation failed - \(error)")
            throw error
        }
    }

    func updateContact(_ contact: Contact) async throws -> Contact {
        print("🔄 HttpContactRepository: Starting contact update")
        print("🔄 HttpContactRepository: Contact - ID: \(contact.id), firstName: \(contact.firstName), lastName: \(contact.lastName ?? "")")
        
        guard let ownerId = userIdProvider() else {
            print("❌ HttpContactRepository: No user ID available for contact update")
            throw ContactError.invalidData("User ID not available")
        }
        
        do {
            let body = contact.toRequestDto(ownerId: ownerId)
            print("🔄 HttpContactRepository: Converted to DTO, making HTTP PUT request")
            
            let responseDto: ContactResponseDto = try await httpClient.put(.updateContact(contact.id), body: body)
            print("✅ HttpContactRepository: HTTP request succeeded")
            print("🔄 HttpContactRepository: Response DTO - ID: \(responseDto.id), firstName: \(responseDto.firstName)")
            
            let updatedContact = responseDto.toEntity()
            print("✅ HttpContactRepository: Contact update completed - Final ID: \(updatedContact.id)")
            return updatedContact
        } catch {
            print("❌ HttpContactRepository: Contact update failed - \(error)")
            throw error
        }
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
            ((contact.lastName?.lowercased().contains(lowercasedQuery)) != nil) ||
            contact.email?.lowercased().contains(lowercasedQuery) == true
        }.sorted { $0.firstName < $1.firstName }
    }
    
    func getContactsByCategory(_ category: ContactCategory) async throws -> [Contact] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return contacts.filter { $0.category == category }.sorted { $0.firstName < $1.firstName }
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
