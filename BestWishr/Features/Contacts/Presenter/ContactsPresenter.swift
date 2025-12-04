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
        let result = await createContactUseCase.execute(contactData)
        
        switch result {
        case .success(let contact):
            break
        case .failure(let error):
            break
        }
        
        return result
    }
    
    func updateContact(_ contact: Contact) async -> Result<Contact, Error> {
        let result = await updateContactUseCase.execute(contact)
        
        switch result {
        case .success(let updatedContact):
            break
        case .failure(let error):
            break
        }
        
        return result
    }
    
    func deleteContact(id: String) async -> Result<Void, Error> {
        await deleteContactUseCase.execute(contactId: id)
    }
}
