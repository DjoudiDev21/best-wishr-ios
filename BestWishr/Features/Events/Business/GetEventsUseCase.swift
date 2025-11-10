import Foundation

struct GetEventsUseCase {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        filter: EventFilter? = nil,
        sortBy: EventSortOption = .date,
        searchQuery: String? = nil
    ) async -> Result<[Event], Error> {
        do {
            var events: [Event]
            
            // Apply search if provided
            if let searchQuery = searchQuery, !searchQuery.isEmpty {
                events = try await repository.searchEvents(query: searchQuery)
            } else {
                events = try await repository.getEvents()
            }
            
            // Apply filter
            if let filter = filter {
                events = events.filter { filter.matches(event: $0) }
            }
            
            // Apply sorting
            events = sortBy.sort(events)
            
            return .success(events)
        } catch {
            return .failure(error)
        }
    }
    
    func executeUpcoming(limit: Int? = nil) async -> Result<[Event], Error> {
        do {
            let events = try await repository.getUpcomingEvents(limit: limit)
            return .success(events)
        } catch {
            return .failure(error)
        }
    }
    
    func executeForContact(contactId: String) async -> Result<[Event], Error> {
        do {
            let events = try await repository.getEventsForContact(contactId: contactId)
            return .success(events)
        } catch {
            return .failure(error)
        }
    }
    
    func executeInDateRange(startDate: Date, endDate: Date) async -> Result<[Event], Error> {
        do {
            let events = try await repository.getEventsInDateRange(startDate: startDate, endDate: endDate)
            return .success(events)
        } catch {
            return .failure(error)
        }
    }
}