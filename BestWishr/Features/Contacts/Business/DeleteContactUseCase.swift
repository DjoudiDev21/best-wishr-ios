import Foundation

struct DeleteContactUseCase {
    private let repository: ContactRepositoryProtocol
    
    init(repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(contactId: String) async -> Result<Void, Error> {
        do {
            // Verify contact exists
            let existingContact = try await repository.getContact(id: contactId)
            guard existingContact != nil else {
                return .failure(ContactError.notFound)
            }
            
            // Delete contact
            try await repository.deleteContact(id: contactId)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}