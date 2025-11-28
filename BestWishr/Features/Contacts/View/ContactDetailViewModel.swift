import Foundation
import SwiftUI
import Combine

@MainActor
final class ContactDetailViewModel: ObservableObject {
    @Published var contact: Contact
    @Published var editableData: ContactCreationData
    @Published var isEditing = false
    @Published var isLoading = false
    @Published var error: Error?
    
    private let contactsStore: ContactsStore
    
    init(contact: Contact, contactsStore: ContactsStore) {
        self.contact = contact
        self.contactsStore = contactsStore
        
        // Initialize editable data from contact
        self.editableData = ContactCreationData(
            firstName: contact.firstName,
            lastName: contact.lastName ?? "",
            email: contact.email ?? "",
            phoneNumber: contact.phoneNumber ?? "",
            phoneCountry: PhoneNumberValidator.detectCountryFromPhoneNumber(contact.phoneNumber),
            dateOfBirth: contact.dateOfBirth,
            category: contact.category,
            description: contact.description ?? "",
            interests: contact.interests ?? [],
            hasBirthday: contact.dateOfBirth != nil
        )
    }
    
    var canSave: Bool {
        editableData.isValid && !isLoading
    }
    
    func startEditing() {
        isEditing = true
        
        // Reset editable data to current contact values
        editableData = ContactCreationData(
            firstName: contact.firstName,
            lastName: contact.lastName ?? "",
            email: contact.email ?? "",
            phoneNumber: contact.phoneNumber ?? "",
            phoneCountry: PhoneNumberValidator.detectCountryFromPhoneNumber(contact.phoneNumber),
            dateOfBirth: contact.dateOfBirth,
            category: contact.category,
            description: contact.description ?? "",
            interests: contact.interests ?? [],
            hasBirthday: contact.dateOfBirth != nil
        )
    }
    
    func cancelEditing() {
        isEditing = false
        error = nil
    }
    
    func saveContact() async -> Bool {
        guard canSave else { return false }
        
        
        isLoading = true
        error = nil
        
        let trimmedPhoneNumber = editableData.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : editableData.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedPhoneNumber = PhoneNumberValidator.validateAndFormat(trimmedPhoneNumber, country: editableData.phoneCountry)

        let updatedContact = Contact(
            id: contact.id,
            firstName: editableData.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: editableData.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : editableData.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: editableData.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : editableData.email.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: formattedPhoneNumber,
            dateOfBirth: editableData.hasBirthday ? editableData.dateOfBirth : nil,
            category: editableData.category,
            description: editableData.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : editableData.description.trimmingCharacters(in: .whitespacesAndNewlines),
            interests: editableData.interests.isEmpty ? nil : editableData.interests,
            avatar: contact.avatar,
            createdAt: contact.createdAt,
            updatedAt: Date()
        )

        // Use the contactsStore to update the contact
        let success = await contactsStore.updateContact(updatedContact)
        
        if success {
            contact = updatedContact
            isEditing = false
        }
        
        isLoading = false
        return success
    }
    
    func deleteContact() async -> Bool {
        let success = await contactsStore.deleteContact(id: contact.id)
        return success
    }
    
    var formattedBirthday: String? {
        guard let birthday = contact.dateOfBirth else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: birthday)
    }
    
    var ageString: String? {
        guard let birthday = contact.dateOfBirth else { return nil }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        guard let age = ageComponents.year else { return nil }
        return "\(age) years old"
    }
}
