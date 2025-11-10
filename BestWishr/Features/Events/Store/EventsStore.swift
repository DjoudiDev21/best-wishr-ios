import Foundation
import Combine

@MainActor
final class EventsStore: ObservableObject {
    // MARK: - Published States
    @Published private(set) var events: [Event] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var searchText = ""
    @Published var selectedFilter: EventFilter = .all
    @Published var sortBy: EventSortOption = .date
    
    // MARK: - Dependencies
    private let presenter: EventsPresenterProtocol
    private let errorHandler: GlobalErrorHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var filteredEvents: [Event] {
        var result = events
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description?.localizedCaseInsensitiveContains(searchText) == true ||
                event.eventType.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply selected filter
        result = result.filter { selectedFilter.matches(event: $0) }
        
        // Apply sorting
        return sortBy.sort(result)
    }
    
    var upcomingEvents: [Event] {
        return events.filter { $0.isUpcoming && !$0.isCompleted }
            .sorted { $0.date < $1.date }
    }
    
    var todayEvents: [Event] {
        return events.filter { $0.isToday }
            .sorted { $0.date < $1.date }
    }
    
    var eventStats: EventStats {
        EventStats(
            totalCount: events.count,
            upcomingCount: upcomingEvents.count,
            todayCount: todayEvents.count,
            completedCount: events.filter { $0.isCompleted }.count
        )
    }
    
    // MARK: - Init
    init(presenter: EventsPresenterProtocol, errorHandler: GlobalErrorHandlerProtocol? = nil) {
        self.presenter = presenter
        self.errorHandler = errorHandler ?? GlobalErrorHandler.shared
        
        setupSearchDebouncing()
    }
    
    // MARK: - Actions
    func loadEvents() async {
        isLoading = true
        error = nil
        
        let result = await presenter.loadEvents(
            filter: nil, // We filter client-side for better UX
            sortBy: sortBy,
            searchQuery: nil // We search client-side for better UX
        )
        
        switch result {
        case .success(let loadedEvents):
            events = loadedEvents
        case .failure(let loadError):
            error = loadError
            errorHandler.handle(loadError)
        }
        
        isLoading = false
    }
    
    func loadUpcomingEvents(limit: Int? = nil) async {
        isLoading = true
        error = nil
        
        let result = await presenter.loadUpcomingEvents(limit: limit)
        
        switch result {
        case .success(let loadedEvents):
            events = loadedEvents
        case .failure(let loadError):
            error = loadError
            errorHandler.handle(loadError)
        }
        
        isLoading = false
    }
    
    func createEvent(_ eventData: EventCreationData) async -> Bool {
        isLoading = true
        error = nil
        
        let result = await presenter.createEvent(eventData)
        
        switch result {
        case .success(let newEvent):
            events.append(newEvent)
            events = sortBy.sort(events)
            isLoading = false
            return true
        case .failure(let createError):
            error = createError
            errorHandler.handle(createError)
            isLoading = false
            return false
        }
    }
    
    func deleteEvent(id: String) async -> Bool {
        isLoading = true
        error = nil
        
        let result = await presenter.deleteEvent(id: id)
        
        switch result {
        case .success:
            events.removeAll { $0.id == id }
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
    
    func clearFilter() {
        selectedFilter = .all
    }
    
    func clearAllFilters() {
        searchText = ""
        selectedFilter = .all
    }
    
    // MARK: - Convenience Methods
    func getEventsForContact(contactId: String) -> [Event] {
        return events.filter { $0.contactId == contactId }
            .sorted { $0.date < $1.date }
    }
    
    func getNextUpcomingEvent() -> Event? {
        return upcomingEvents.first
    }
    
    func getEventsInNext7Days() -> [Event] {
        let calendar = Calendar.current
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        
        return events.filter { event in
            event.isUpcoming && event.date <= nextWeek
        }.sorted { $0.date < $1.date }
    }
    
    // MARK: - Private Methods
    private func setupSearchDebouncing() {
        // React to sort changes only - search and filter are handled by computed property
        $sortBy
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.loadEvents()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Supporting Types
struct EventStats {
    let totalCount: Int
    let upcomingCount: Int
    let todayCount: Int
    let completedCount: Int
}