import Foundation
import SwiftUI
import Combine

@MainActor
final class ContactsViewModel: ObservableObject {
    @Published var showingAddContact = false
    @Published var selectedContact: Contact?
    @Published var showingContactDetail = false
    @Published var selectedCategory: ContactCategory? {
        didSet {
            contactsStore.selectedCategory = selectedCategory
        }
    }
    
    private let contactsStore: ContactsStore
    private let appStats: AppStats
    private var cancellables = Set<AnyCancellable>()
    
    init(contactsStore: ContactsStore, appStats: AppStats) {
        self.contactsStore = contactsStore
        self.appStats = appStats
        self.selectedCategory = contactsStore.selectedCategory
        
        setupBindings()
    }
    
    private func setupBindings() {
        contactsStore.$selectedCategory
            .sink { [weak self] newValue in
                if self?.selectedCategory != newValue {
                    self?.selectedCategory = newValue
                }
            }
            .store(in: &cancellables)
    }
    
    var contacts: [Contact] {
        contactsStore.filteredContacts
    }
    
    var isLoading: Bool {
        contactsStore.isLoading
    }
    
    var searchText: String {
        get { contactsStore.searchText }
        set { contactsStore.searchText = newValue }
    }
    
    
    var contactCount: Int {
        contacts.count
    }
    
    var upcomingEventsCount: Int {
        appStats.upcomingEventsCount
    }
    
    var allContacts: [Contact] {
        contactsStore.contacts
    }
    
    var emptyStateTitle: String {
        if !searchText.isEmpty {
            return "No Results Found"
        } else if selectedCategory != nil {
            return "No Contacts in Category"
        } else {
            return "No Contacts Yet"
        }
    }
    
    var emptyStateMessage: String {
        if !searchText.isEmpty {
            return "Try adjusting your search terms or clear filters to see more contacts."
        } else if selectedCategory != nil {
            return "You don't have any contacts in this category yet."
        } else {
            return "Start building your contact list to keep track of important dates and celebrations."
        }
    }
    
    var emptyStateIcon: String {
        if searchText.isEmpty && selectedCategory == nil {
            return "person.3"
        } else {
            return "magnifyingglass"
        }
    }
    
    var showEmptyStateAction: Bool {
        searchText.isEmpty && selectedCategory == nil
    }
    
    func loadContacts() async {
        await contactsStore.loadContacts()
    }
    
    func showAddContact() {
        showingAddContact = true
    }
    
    func hideAddContact() {
        showingAddContact = false
    }
    
    func selectContact(_ contact: Contact) {
        selectedContact = contact
        showingContactDetail = true
    }
    
    func clearSelection() {
        selectedContact = nil
        showingContactDetail = false
    }
    
    func clearSearch() {
        contactsStore.clearSearch()
    }
    
    func clearCategoryFilter() {
        contactsStore.clearCategoryFilter()
    }
    
    func clearAllFilters() {
        contactsStore.clearAllFilters()
    }
    
    func deleteContact(_ contact: Contact) async {
        await contactsStore.deleteContact(id: contact.id)
    }
    
    func hasUpcomingEvent(for contact: Contact) -> Bool {
        // TODO: Calculate from events module when available
        return false
    }
}