import Foundation

struct UpdateContactUseCase {
    private let repository: ContactRepositoryProtocol
    
    init(repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ contact: Contact) async -> Result<Contact, Error> {
        do {
            // Validate input
            let validation = validateContact(contact)
            if let validationError = validation {
                return .failure(validationError)
            }
            
            // Update contact in repository
            let updatedContact = try await repository.updateContact(contact)
            return .success(updatedContact)
        } catch {
            return .failure(error)
        }
    }
    
    private func validateContact(_ contact: Contact) -> Error? {
        // Validate first name
        if contact.firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            return ContactError.invalidData("First name is required")
        }
        
        // Validate email format if provided
        if let email = contact.email, !email.isEmpty {
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            if !emailPredicate.evaluate(with: email) {
                return ContactError.invalidData("Invalid email format")
            }
        }
        
        return nil
    }
}
