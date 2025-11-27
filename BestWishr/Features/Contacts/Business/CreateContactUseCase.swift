import Foundation

struct CreateContactUseCase {
    private let repository: ContactRepositoryProtocol
    
    init(repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ contactData: ContactCreationData) async -> Result<Contact, Error> {
        print("🏗️ CreateContactUseCase: Starting execution")
        print("🏗️ CreateContactUseCase: Input data - firstName: \(contactData.firstName), lastName: \(contactData.lastName)")
        
        do {
            // Validate input
            print("🏗️ CreateContactUseCase: Validating contact data")
            let validation = validateContactData(contactData)
            if let validationError = validation {
                print("❌ CreateContactUseCase: Validation failed - \(validationError)")
                return .failure(validationError)
            }
            print("✅ CreateContactUseCase: Validation passed")
            
            // Create contact entity
            print("🏗️ CreateContactUseCase: Creating contact entity")
            let contact = contactData.toContact()
            print("🏗️ CreateContactUseCase: Contact entity created - ID: \(contact.id)")
            
            // Save to repository
            print("🏗️ CreateContactUseCase: Calling repository.createContact")
            let savedContact = try await repository.createContact(contact)
            print("✅ CreateContactUseCase: Repository call succeeded - Saved contact ID: \(savedContact.id)")
            
            return .success(savedContact)
        } catch {
            print("❌ CreateContactUseCase: Repository call failed - \(error)")
            return .failure(error)
        }
    }
    
    private func validateContactData(_ data: ContactCreationData) -> Error? {
        // Validate first name
        if data.firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            return ContactError.invalidData("First name is required")
        }
        
        
        // Validate email format if provided
        if !data.email.isEmpty {
            if !isValidEmail(data.email) {
                return ContactError.invalidData("Please enter a valid email address")
            }
        }
        
        // Validate phone number format if provided
        if !data.phoneNumber.isEmpty {
            if !isValidPhoneNumber(data.phoneNumber) {
                return ContactError.invalidData("Please enter a valid phone number")
            }
        }
        
        // Validate date of birth if provided
        if let dateOfBirth = data.dateOfBirth {
            if dateOfBirth > Date() {
                return ContactError.invalidData("Date of birth cannot be in the future")
            }
        }
        
        return nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^[+]?[0-9\\s\\-\\(\\)]{10,}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
}