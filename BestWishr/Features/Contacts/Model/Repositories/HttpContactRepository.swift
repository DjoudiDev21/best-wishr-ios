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
        guard let ownerId = userIdProvider() else {
            throw ContactError.invalidData("User ID not available")
        }
                
        do {
            let contactDtos: [ContactResponseDto] = try await httpClient.get(.listContacts(ownerId: ownerId))
            let contacts = contactDtos.map { $0.toEntity() }
            return contacts.sorted { $0.firstName < $1.firstName }
        } catch {
            throw error
        }
    }
    
    func getContact(id: String) async throws -> Contact? {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return contacts.first { $0.id == id }
    }
    
    func createContact(_ contact: Contact) async throws -> Contact {
        guard let ownerId = userIdProvider() else {
            throw ContactError.invalidData("User ID not available")
        }
        
        do {
            let body = contact.toRequestDto(ownerId: ownerId)
            
            let responseDto: ContactResponseDto = try await httpClient.post(.createContact, body: body)
            
            let savedContact = responseDto.toEntity()
            return savedContact
        } catch {
            throw error
        }
    }

    func updateContact(_ contact: Contact) async throws -> Contact {
        do {
            let body = contact.toUpdateRequestDto()
            let responseDto: ContactResponseDto = try await httpClient.put(.updateContact(contact.id), body: body)
            let updatedContact = responseDto.toEntity()
            return updatedContact
        } catch {
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
