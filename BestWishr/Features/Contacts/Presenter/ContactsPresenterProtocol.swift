import Foundation

protocol ContactsPresenterProtocol {
    func loadContacts(filters: ContactFilters?, sortBy: ContactSortOption) async -> Result<[Contact], Error>
    func createContact(_ contactData: ContactCreationData) async -> Result<Contact, Error>
    func deleteContact(id: String) async -> Result<Void, Error>
}