import Foundation

protocol ContactRepositoryProtocol {
    func getContacts() async throws -> [Contact]
    func getContact(id: String) async throws -> Contact?
    func createContact(_ contact: Contact) async throws -> Contact
    func updateContact(_ contact: Contact) async throws -> Contact
    func deleteContact(id: String) async throws
    func searchContacts(query: String) async throws -> [Contact]
    func getContactsByCategory(_ category: ContactCategory) async throws -> [Contact]
}