import Foundation

protocol EventRepositoryProtocol {
    // MARK: - Event CRUD Operations
    func getEvents() async throws -> [Event]
    func getEvent(id: String) async throws -> Event?
    func getUpcomingEvents(limit: Int?) async throws -> [Event]
    func getEventsForContact(contactId: String) async throws -> [Event]
    func getEventsInDateRange(startDate: Date, endDate: Date) async throws -> [Event]
    
    func createEvent(_ event: Event) async throws -> Event
    func updateEvent(_ event: Event) async throws -> Event
    func deleteEvent(id: String) async throws
    
    // MARK: - Event Filtering and Search
    func searchEvents(query: String) async throws -> [Event]
    func getEventsByType(_ eventType: EventType) async throws -> [Event]
    func getCompletedEvents() async throws -> [Event]
    
    // MARK: - Event Statistics
    func getEventsCount() async throws -> Int
    func getUpcomingEventsCount() async throws -> Int
}

// MARK: - Event Errors
enum EventError: LocalizedError {
    case notFound
    case invalidData(String)
    case dateConflict
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Event not found"
        case .invalidData(let message):
            return message
        case .dateConflict:
            return "Event date conflicts with existing event"
        case .networkError:
            return "Network connection error"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}