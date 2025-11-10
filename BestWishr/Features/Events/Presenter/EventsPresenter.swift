import Foundation

final class EventsPresenter: EventsPresenterProtocol {
    
    private let getEventsUseCase: GetEventsUseCase
    private let createEventUseCase: CreateEventUseCase
    private let deleteEventUseCase: DeleteEventUseCase
    
    init(
        getEventsUseCase: GetEventsUseCase,
        createEventUseCase: CreateEventUseCase,
        deleteEventUseCase: DeleteEventUseCase
    ) {
        self.getEventsUseCase = getEventsUseCase
        self.createEventUseCase = createEventUseCase
        self.deleteEventUseCase = deleteEventUseCase
    }
    
    func loadEvents(
        filter: EventFilter? = nil,
        sortBy: EventSortOption = .date,
        searchQuery: String? = nil
    ) async -> Result<[Event], Error> {
        return await getEventsUseCase.execute(
            filter: filter,
            sortBy: sortBy,
            searchQuery: searchQuery
        )
    }
    
    func loadUpcomingEvents(limit: Int? = nil) async -> Result<[Event], Error> {
        return await getEventsUseCase.executeUpcoming(limit: limit)
    }
    
    func loadEventsForContact(contactId: String) async -> Result<[Event], Error> {
        return await getEventsUseCase.executeForContact(contactId: contactId)
    }
    
    func loadEventsInDateRange(startDate: Date, endDate: Date) async -> Result<[Event], Error> {
        return await getEventsUseCase.executeInDateRange(startDate: startDate, endDate: endDate)
    }
    
    func createEvent(_ eventData: EventCreationData) async -> Result<Event, Error> {
        return await createEventUseCase.execute(eventData)
    }
    
    func deleteEvent(id: String) async -> Result<Void, Error> {
        return await deleteEventUseCase.execute(eventId: id)
    }
}