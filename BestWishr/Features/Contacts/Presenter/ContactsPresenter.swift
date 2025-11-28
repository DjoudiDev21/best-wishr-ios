import Foundation

class ContactsPresenter: ContactsPresenterProtocol {
    private let getContactsUseCase: GetContactsUseCase
    private let createContactUseCase: CreateContactUseCase
    private let updateContactUseCase: UpdateContactUseCase
    private let deleteContactUseCase: DeleteContactUseCase
    
    init(
        getContactsUseCase: GetContactsUseCase,
        createContactUseCase: CreateContactUseCase,
        updateContactUseCase: UpdateContactUseCase,
        deleteContactUseCase: DeleteContactUseCase
    ) {
        self.getContactsUseCase = getContactsUseCase
        self.createContactUseCase = createContactUseCase
        self.updateContactUseCase = updateContactUseCase
        self.deleteContactUseCase = deleteContactUseCase
    }
    
    func loadContacts(filters: ContactFilters? = nil, sortBy: ContactSortOption = .firstName) async -> Result<[Contact], Error> {
        await getContactsUseCase.execute(filters: filters, sortBy: sortBy)
    }
    
    func createContact(_ contactData: ContactCreationData) async -> Result<Contact, Error> {
        print("🎭 ContactsPresenter: Received create contact request")
        print("🎭 ContactsPresenter: Contact data - firstName: \(contactData.firstName), lastName: \(contactData.lastName)")
        
        let result = await createContactUseCase.execute(contactData)
        
        switch result {
        case .success(let contact):
            print("✅ ContactsPresenter: CreateContactUseCase succeeded - Contact ID: \(contact.id)")
        case .failure(let error):
            print("❌ ContactsPresenter: CreateContactUseCase failed - \(error)")
        }
        
        return result
    }
    
    func updateContact(_ contact: Contact) async -> Result<Contact, Error> {
        print("🎭 ContactsPresenter: Received update contact request")
        print("🎭 ContactsPresenter: Contact - ID: \(contact.id), firstName: \(contact.firstName), lastName: \(contact.lastName ?? "")")
        
        let result = await updateContactUseCase.execute(contact)
        
        switch result {
        case .success(let updatedContact):
            print("✅ ContactsPresenter: UpdateContactUseCase succeeded - Contact ID: \(updatedContact.id)")
        case .failure(let error):
            print("❌ ContactsPresenter: UpdateContactUseCase failed - \(error)")
        }
        
        return result
    }
    
    func deleteContact(id: String) async -> Result<Void, Error> {
        await deleteContactUseCase.execute(contactId: id)
    }
}
