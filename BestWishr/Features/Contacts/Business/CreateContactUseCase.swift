import Foundation

struct CreateContactUseCase {
    private let repository: ContactRepositoryProtocol
    
    init(repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ contactData: ContactCreationData) async -> Result<Contact, Error> {
        do {
            // Validate input
            let validation = validateContactData(contactData)
            if let validationError = validation {
                return .failure(validationError)
            }
            
            // Create contact entity
            let contact = contactData.toContact()
            
            // Save to repository
            let savedContact = try await repository.createContact(contact)
            
            return .success(savedContact)
        } catch {
            return .failure(error)
        }
    }
    
    private func validateContactData(_ data: ContactCreationData) -> Error? {
        // Validate first name
        if data.firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            return ContactError.invalidData("First name is required")
        }
        
        // Validate last name
        if data.lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            return ContactError.invalidData("Last name is required")
        }
        
        // Validate email format if provided
        if let email = data.email, !email.isEmpty {
            if !isValidEmail(email) {
                return ContactError.invalidData("Please enter a valid email address")
            }
        }
        
        // Validate phone number format if provided
        if let phone = data.phoneNumber, !phone.isEmpty {
            if !isValidPhoneNumber(phone) {
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