import Foundation

final class MockEventRepository: EventRepositoryProtocol {
    
    private var events: [Event] = []
    
    init() {
        loadMockData()
    }
    
    // MARK: - Event CRUD Operations
    
    func getEvents() async throws -> [Event] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        return events.sorted { $0.date < $1.date }
    }
    
    func getEvent(id: String) async throws -> Event? {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return events.first { $0.id == id }
    }
    
    func getUpcomingEvents(limit: Int? = nil) async throws -> [Event] {
        try await Task.sleep(nanoseconds: 250_000_000) // 0.25 seconds
        let upcoming = events.filter { $0.isUpcoming && !$0.isCompleted }
            .sorted { $0.date < $1.date }
        
        if let limit = limit {
            return Array(upcoming.prefix(limit))
        }
        return upcoming
    }
    
    func getEventsForContact(contactId: String) async throws -> [Event] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return events.filter { $0.contactId == contactId }
            .sorted { $0.date < $1.date }
    }
    
    func getEventsInDateRange(startDate: Date, endDate: Date) async throws -> [Event] {
        try await Task.sleep(nanoseconds: 250_000_000) // 0.25 seconds
        return events.filter { event in
            event.date >= startDate && event.date <= endDate
        }.sorted { $0.date < $1.date }
    }
    
    func createEvent(_ event: Event) async throws -> Event {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Validate required fields
        guard !event.title.isEmpty else {
            throw EventError.invalidData("Event title is required")
        }
        
        // Check for date conflicts (same contact, same day, same type)
        if let contactId = event.contactId {
            let calendar = Calendar.current
            let existingEvents = events.filter { existingEvent in
                existingEvent.contactId == contactId &&
                existingEvent.eventType == event.eventType &&
                calendar.isDate(existingEvent.date, inSameDayAs: event.date)
            }
            
            if !existingEvents.isEmpty {
                throw EventError.dateConflict
            }
        }
        
        let newEvent = Event(
            id: event.id,
            title: event.title,
            description: event.description,
            eventType: event.eventType,
            contactId: event.contactId,
            date: event.date,
            recurrence: event.recurrence,
            reminders: event.reminders,
            isCompleted: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        events.append(newEvent)
        return newEvent
    }
    
    func updateEvent(_ event: Event) async throws -> Event {
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4 seconds
        
        guard let index = events.firstIndex(where: { $0.id == event.id }) else {
            throw EventError.notFound
        }
        
        // Validate required fields
        guard !event.title.isEmpty else {
            throw EventError.invalidData("Event title is required")
        }
        
        let updatedEvent = Event(
            id: event.id,
            title: event.title,
            description: event.description,
            eventType: event.eventType,
            contactId: event.contactId,
            date: event.date,
            recurrence: event.recurrence,
            reminders: event.reminders,
            isCompleted: event.isCompleted,
            createdAt: event.createdAt,
            updatedAt: Date()
        )
        
        events[index] = updatedEvent
        return updatedEvent
    }
    
    func deleteEvent(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        guard let index = events.firstIndex(where: { $0.id == id }) else {
            throw EventError.notFound
        }
        
        events.remove(at: index)
    }
    
    // MARK: - Event Filtering and Search
    
    func searchEvents(query: String) async throws -> [Event] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        let lowercasedQuery = query.lowercased()
        return events.filter { event in
            event.title.lowercased().contains(lowercasedQuery) ||
            event.description?.lowercased().contains(lowercasedQuery) == true ||
            event.eventType.rawValue.lowercased().contains(lowercasedQuery)
        }.sorted { $0.date < $1.date }
    }
    
    func getEventsByType(_ eventType: EventType) async throws -> [Event] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return events.filter { $0.eventType == eventType }
            .sorted { $0.date < $1.date }
    }
    
    func getCompletedEvents() async throws -> [Event] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return events.filter { $0.isCompleted }
            .sorted { $0.date > $1.date }
    }
    
    // MARK: - Event Statistics
    
    func getEventsCount() async throws -> Int {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        return events.count
    }
    
    func getUpcomingEventsCount() async throws -> Int {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        return events.filter { $0.isUpcoming && !$0.isCompleted }.count
    }
    
    // MARK: - Private Methods
    
    private func loadMockData() {
        let now = Date()
        let calendar = Calendar.current
        
        events = [
            // Upcoming birthdays
            Event(
                id: "1",
                title: "John's Birthday",
                description: "John Doe's 29th birthday celebration",
                eventType: .birthday,
                contactId: "1", // Links to John Doe contact
                date: calendar.date(byAdding: .day, value: 5, to: now) ?? now,
                recurrence: RecurrenceRule(frequency: .yearly),
                reminders: [
                    EventReminder(interval: .oneWeek),
                    EventReminder(interval: .oneDay)
                ]
            ),
            
            Event(
                id: "2",
                title: "Jane's Birthday",
                description: "Jane Smith's birthday party",
                eventType: .birthday,
                contactId: "2", // Links to Jane Smith contact
                date: calendar.date(byAdding: .day, value: 12, to: now) ?? now,
                recurrence: RecurrenceRule(frequency: .yearly),
                reminders: [
                    EventReminder(interval: .threeDays),
                    EventReminder(interval: .oneDay)
                ]
            ),
            
            // Anniversary
            Event(
                id: "3",
                title: "Wedding Anniversary",
                description: "Mike and Sarah's 5th wedding anniversary",
                eventType: .anniversary,
                contactId: nil,
                date: calendar.date(byAdding: .day, value: 25, to: now) ?? now,
                recurrence: RecurrenceRule(frequency: .yearly),
                reminders: [
                    EventReminder(interval: .oneWeek),
                    EventReminder(interval: .threeDays)
                ]
            ),
            
            // Past events
            Event(
                id: "4",
                title: "David's Birthday",
                description: "David Brown's birthday celebration",
                eventType: .birthday,
                contactId: "5", // Links to David Brown contact
                date: calendar.date(byAdding: .day, value: -15, to: now) ?? now,
                recurrence: RecurrenceRule(frequency: .yearly),
                reminders: [],
                isCompleted: true
            ),
            
            // Meeting
            Event(
                id: "5",
                title: "Project Kickoff Meeting",
                description: "Quarterly planning meeting",
                eventType: .meeting,
                contactId: nil,
                date: calendar.date(byAdding: .day, value: 2, to: now) ?? now,
                reminders: [
                    EventReminder(interval: .oneDay),
                    EventReminder(interval: .oneHour)
                ]
            ),
            
            // Holiday
            Event(
                id: "6",
                title: "Christmas",
                description: "Christmas celebration with family",
                eventType: .holiday,
                contactId: nil,
                date: calendar.date(byAdding: .month, value: 2, to: now) ?? now,
                recurrence: RecurrenceRule(frequency: .yearly),
                reminders: [
                    EventReminder(interval: .oneMonth),
                    EventReminder(interval: .oneWeek)
                ]
            ),
            
            // Today's event
            Event(
                id: "7",
                title: "Emily's Birthday",
                description: "Emily Davis's special day",
                eventType: .birthday,
                contactId: "6", // Links to Emily Davis contact
                date: now,
                recurrence: RecurrenceRule(frequency: .yearly),
                reminders: [
                    EventReminder(interval: .oneDay, isEnabled: false) // Already triggered
                ]
            )
        ]
    }
}