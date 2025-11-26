import Foundation
import Combine

@MainActor
final class ContactsStore: ObservableObject {
    // MARK: - Published States
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var searchText = ""
    @Published var selectedCategory: ContactCategory?
    @Published var sortBy: ContactSortOption = .firstName
    
    // MARK: - Dependencies
    private let presenter: ContactsPresenterProtocol
    private let errorHandler: GlobalErrorHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var filteredContacts: [Contact] {
        var result = contacts
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { contact in
                contact.firstName.localizedCaseInsensitiveContains(searchText) ||
                contact.lastName.localizedCaseInsensitiveContains(searchText) ||
                contact.email?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        // Apply category filter
        if let selectedCategory = selectedCategory {
            result = result.filter { $0.category == selectedCategory }
        }
        
        return result
    }
    
    var contactStats: ContactStats {
        ContactStats(
            totalCount: contacts.count,
            thisMonthCount: calculateThisMonthBirthdays()
        )
    }
    
    // MARK: - Init
    init(presenter: ContactsPresenterProtocol, errorHandler: GlobalErrorHandlerProtocol? = nil) {
        self.presenter = presenter
        self.errorHandler = errorHandler ?? GlobalErrorHandler.shared
        
        setupSearchDebouncing()
    }
    
    // MARK: - Actions
    func loadContacts() async {
        isLoading = true
        error = nil
        
        let result = await presenter.loadContacts(filters: nil, sortBy: sortBy)
        
        switch result {
        case .success(let loadedContacts):
            contacts = loadedContacts
        case .failure(let loadError):
            error = loadError
            errorHandler.handle(loadError)
        }
        
        isLoading = false
    }
    
    func createContact(_ contactData: ContactCreationData) async -> Bool {
        isLoading = true
        error = nil
        
        let result = await presenter.createContact(contactData)
        
        switch result {
        case .success(let newContact):
            contacts.append(newContact)
            contacts = contacts.sorted { $0.firstName < $1.firstName }
            isLoading = false
            return true
        case .failure(let createError):
            error = createError
            errorHandler.handle(createError)
            isLoading = false
            return false
        }
    }
    
    func deleteContact(id: String) async -> Bool {
        isLoading = true
        error = nil
        
        let result = await presenter.deleteContact(id: id)
        
        switch result {
        case .success:
            contacts.removeAll { $0.id == id }
            isLoading = false
            return true
        case .failure(let deleteError):
            error = deleteError
            errorHandler.handle(deleteError)
            isLoading = false
            return false
        }
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func clearCategoryFilter() {
        selectedCategory = nil
    }
    
    func clearAllFilters() {
        searchText = ""
        selectedCategory = nil
    }
    
    // MARK: - Private Methods
    private func setupSearchDebouncing() {
        // React to sort changes only - search and category are handled by computed property
        $sortBy
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.loadContacts()
                }
            }
            .store(in: &cancellables)
    }
    
    private func calculateThisMonthBirthdays() -> Int {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        
        return contacts.filter { contact in
            guard let birthDate = contact.dateOfBirth else { return false }
            let birthMonth = calendar.component(.month, from: birthDate)
            return birthMonth == currentMonth
        }.count
    }
}

// MARK: - Supporting Types

struct ContactStats {
    let totalCount: Int
    let thisMonthCount: Int
}