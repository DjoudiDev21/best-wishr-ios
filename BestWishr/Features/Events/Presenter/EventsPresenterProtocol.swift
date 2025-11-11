import Foundation

protocol EventsPresenterProtocol {
    func loadEvents(
        filter: EventFilter?,
        sortBy: EventSortOption,
        searchQuery: String?
    ) async -> Result<[Event], Error>
    
    func loadUpcomingEvents(limit: Int?) async -> Result<[Event], Error>
    func loadRecentEvents() async -> Result<[Event], Error>
    func loadEventsForContact(contactId: String) async -> Result<[Event], Error>
    func loadEventsInDateRange(startDate: Date, endDate: Date) async -> Result<[Event], Error>
    
    func createEvent(_ eventData: EventCreationData) async -> Result<Event, Error>
    func deleteEvent(id: String) async -> Result<Void, Error>
}