import Foundation

class ContactsPresenter: ContactsPresenterProtocol {
    private let getContactsUseCase: GetContactsUseCase
    private let createContactUseCase: CreateContactUseCase
    private let deleteContactUseCase: DeleteContactUseCase
    
    init(
        getContactsUseCase: GetContactsUseCase,
        createContactUseCase: CreateContactUseCase,
        deleteContactUseCase: DeleteContactUseCase
    ) {
        self.getContactsUseCase = getContactsUseCase
        self.createContactUseCase = createContactUseCase
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
    
    func deleteContact(id: String) async -> Result<Void, Error> {
        await deleteContactUseCase.execute(contactId: id)
    }
}
