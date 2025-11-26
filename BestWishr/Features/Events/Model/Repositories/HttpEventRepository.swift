import Foundation

final class HttpEventRepository: EventRepositoryProtocol {
    private let httpClient: HttpClientProtocol
    private let userIdProvider: () -> String?
    
    init(httpClient: HttpClientProtocol, userIdProvider: @escaping () -> String?) {
        self.httpClient = httpClient
        self.userIdProvider = userIdProvider
    }
    
    // MARK: - Event CRUD Operations
    func getEvents() async throws -> [Event] {
        print("🏪 HttpEventRepository: Getting events...")
        
        guard let ownerId = userIdProvider() else {
            print("❌ HttpEventRepository: No user ID available")
            throw EventError.invalidData("User ID not available")
        }
        
        print("🏪 HttpEventRepository: Using owner ID: \(ownerId)")
        
        do {
            let events: [Event] = try await httpClient.get(.listEvents(ownerId: ownerId))
            print("✅ HttpEventRepository: Successfully retrieved \(events.count) events")
            return events.sorted { $0.date < $1.date }
        } catch {
            print("❌ HttpEventRepository: Failed to get events - \(error)")
            throw error
        }
    }
    
    func getEvent(id: String) async throws -> Event? {
        // Note: This would typically be a separate endpoint like .getEvent(id)
        let events = try await getEvents()
        return events.first { $0.id == id }
    }
    
    func getUpcomingEvents(limit: Int?) async throws -> [Event] {
        let allEvents = try await getEvents()
        let upcoming = allEvents.filter { $0.date > Date() }
            .sorted { $0.date < $1.date }
        
        if let limit = limit {
            return Array(upcoming.prefix(limit))
        }
        return upcoming
    }
    
    func getEventsForContact(contactId: String) async throws -> [Event] {
        let allEvents = try await getEvents()
        return allEvents.filter { $0.contactId == contactId }
            .sorted { $0.date < $1.date }
    }
    
    func getEventsInDateRange(startDate: Date, endDate: Date) async throws -> [Event] {
        let allEvents = try await getEvents()
        return allEvents.filter { event in
            event.date >= startDate && event.date <= endDate
        }.sorted { $0.date < $1.date }
    }
    
    func createEvent(_ event: Event) async throws -> Event {
        return try await httpClient.post(.createEvent, body: event)
    }
    
    func updateEvent(_ event: Event) async throws -> Event {
        return try await httpClient.put(.updateEvent(event.id), body: event)
    }
    
    func deleteEvent(id: String) async throws {
        try await httpClient.delete(.deleteEvent(id))
    }
    
    // MARK: - Event Filtering and Search
    func searchEvents(query: String) async throws -> [Event] {
        let allEvents = try await getEvents()
        let lowercasedQuery = query.lowercased()
        
        return allEvents.filter { event in
            event.title.lowercased().contains(lowercasedQuery) ||
            event.description?.lowercased().contains(lowercasedQuery) == true
        }.sorted { $0.date < $1.date }
    }
    
    func getEventsByType(_ eventType: EventType) async throws -> [Event] {
        let allEvents = try await getEvents()
        return allEvents.filter { $0.eventType == eventType }
            .sorted { $0.date < $1.date }
    }
    
    func getCompletedEvents() async throws -> [Event] {
        let allEvents = try await getEvents()
        return allEvents.filter { $0.date < Date() }
            .sorted { $0.date > $1.date } // Most recent first for completed events
    }
    
    // MARK: - Event Statistics
    func getEventsCount() async throws -> Int {
        let events = try await getEvents()
        return events.count
    }
    
    func getUpcomingEventsCount() async throws -> Int {
        let upcoming = try await getUpcomingEvents(limit: nil)
        return upcoming.count
    }
}

// MARK: - Helper Types
private struct EmptyBody: Codable {}

// MARK: - Event Errors
enum EventError: LocalizedError {
    case notFound
    case invalidData(String)
    case networkError
    case dateConflict
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Event not found"
        case .invalidData(let message):
            return message
        case .networkError:
            return "Network connection error"
        case .dateConflict:
            return "date conflict"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
