import Foundation
import SwiftUI
import Combine

@MainActor
final class AddContactViewModel: ObservableObject {
    @Published var contactData = ContactCreationData()
    @Published var isSubmitting = false
    @Published var showingError = false
    @Published var errorMessage = ""
    
    private let contactsStore: ContactsStore
    private let errorHandler: GlobalErrorHandlerProtocol
    
    init(contactsStore: ContactsStore, errorHandler: GlobalErrorHandlerProtocol? = nil) {
        self.contactsStore = contactsStore
        self.errorHandler = errorHandler ?? GlobalErrorHandler.shared
    }
    
    var isValid: Bool {
        contactData.isValid
    }
    
    var canSave: Bool {
        isValid && !isSubmitting
    }
    
    func saveContact() async -> Bool {
        guard canSave else { return false }
        
        isSubmitting = true
        errorMessage = ""
        showingError = false
        
        let success = await contactsStore.createContact(contactData)
        
        if !success {
            showingError = true
            errorMessage = "Failed to create contact. Please try again."
        }
        
        isSubmitting = false
        return success
    }
    
    func clearForm() {
        contactData = ContactCreationData()
    }
    
    func validateAndShowErrors() -> Bool {
        guard !contactData.firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("First name is required")
            return false
        }
        
        if !contactData.email.isEmpty && !isValidEmail(contactData.email) {
            showError("Please enter a valid email address")
            return false
        }
        
        if !contactData.phoneNumber.isEmpty && !isValidPhoneNumber(contactData.phoneNumber) {
            showError("Please enter a valid phone number")
            return false
        }
        
        if let dateOfBirth = contactData.dateOfBirth, dateOfBirth > Date() {
            showError("Date of birth cannot be in the future")
            return false
        }
        
        return true
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
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
