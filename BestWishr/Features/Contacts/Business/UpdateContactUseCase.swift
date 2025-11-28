import Foundation

struct UpdateContactUseCase {
    private let repository: ContactRepositoryProtocol
    
    init(repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ contact: Contact) async -> Result<Contact, Error> {
        print("🔄 UpdateContactUseCase: Starting execution")
        print("🔄 UpdateContactUseCase: Contact - ID: \(contact.id), firstName: \(contact.firstName), lastName: \(contact.lastName ?? "")")
        
        do {
            // Validate input
            print("🔄 UpdateContactUseCase: Validating contact data")
            let validation = validateContact(contact)
            if let validationError = validation {
                print("❌ UpdateContactUseCase: Validation failed - \(validationError)")
                return .failure(validationError)
            }
            print("✅ UpdateContactUseCase: Validation passed")
            
            // Update contact in repository
            print("🔄 UpdateContactUseCase: Calling repository.updateContact")
            let updatedContact = try await repository.updateContact(contact)
            print("✅ UpdateContactUseCase: Repository call succeeded - Updated contact ID: \(updatedContact.id)")
            
            return .success(updatedContact)
        } catch {
            print("❌ UpdateContactUseCase: Repository call failed - \(error)")
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