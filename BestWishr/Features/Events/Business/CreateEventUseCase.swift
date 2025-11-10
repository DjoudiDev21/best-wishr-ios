import Foundation

struct CreateEventUseCase {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ eventData: EventCreationData) async -> Result<Event, Error> {
        do {
            // Validate event data
            let validationResult = validate(eventData)
            if case .failure(let error) = validationResult {
                return .failure(error)
            }
            
            // Create the event
            let event = eventData.toEvent()
            let createdEvent = try await repository.createEvent(event)
            
            return .success(createdEvent)
        } catch {
            return .failure(error)
        }
    }
    
    private func validate(_ eventData: EventCreationData) -> Result<Void, Error> {
        // Validate title
        guard !eventData.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .failure(EventError.invalidData("Event title cannot be empty"))
        }
        
        // Validate title length
        guard eventData.title.count <= 100 else {
            return .failure(EventError.invalidData("Event title cannot exceed 100 characters"))
        }
        
        // Validate description length
        if !eventData.description.isEmpty && eventData.description.count > 500 {
            return .failure(EventError.invalidData("Event description cannot exceed 500 characters"))
        }
        
        // Validate date (cannot be more than 10 years in the future)
        let tenYearsFromNow = Calendar.current.date(byAdding: .year, value: 10, to: Date()) ?? Date()
        guard eventData.date <= tenYearsFromNow else {
            return .failure(EventError.invalidData("Event date cannot be more than 10 years in the future"))
        }
        
        // Validate recurrence rule
        if eventData.isRecurring {
            let recurrence = RecurrenceRule(frequency: .yearly)
            let validationResult = validateRecurrence(recurrence, eventDate: eventData.date)
            if case .failure(let error) = validationResult {
                return .failure(error)
            }
        }
        
        // Validate reminders
        if eventData.hasReminders {
            let reminderIntervals = eventData.eventType.defaultReminders
            let reminders = reminderIntervals.map { EventReminder(interval: $0) }
            let reminderValidation = validateReminders(reminders, eventDate: eventData.date)
            if case .failure(let error) = reminderValidation {
                return .failure(error)
            }
        }
        
        return .success(())
    }
    
    private func validateRecurrence(_ recurrence: RecurrenceRule, eventDate: Date) -> Result<Void, Error> {
        // Validate interval
        guard recurrence.interval > 0 && recurrence.interval <= 999 else {
            return .failure(EventError.invalidData("Recurrence interval must be between 1 and 999"))
        }
        
        // Validate end date
        if let endDate = recurrence.endDate {
            guard endDate > eventDate else {
                return .failure(EventError.invalidData("Recurrence end date must be after the event date"))
            }
            
            // Check if end date is reasonable (not more than 50 years)
            let maxEndDate = Calendar.current.date(byAdding: .year, value: 50, to: eventDate) ?? eventDate
            guard endDate <= maxEndDate else {
                return .failure(EventError.invalidData("Recurrence end date cannot be more than 50 years from the event date"))
            }
        }
        
        return .success(())
    }
    
    private func validateReminders(_ reminders: [EventReminder], eventDate: Date) -> Result<Void, Error> {
        // Validate reminder count
        guard reminders.count <= 10 else {
            return .failure(EventError.invalidData("Cannot have more than 10 reminders per event"))
        }
        
        // Validate each reminder
        for reminder in reminders {
            let reminderDate = reminder.reminderDate(for: eventDate)
            
            // Reminder cannot be in the past
            guard reminderDate >= Date() else {
                return .failure(EventError.invalidData("Reminder time cannot be in the past"))
            }
        }
        
        // Check for duplicate reminder intervals
        let intervals = reminders.map { $0.interval }
        let uniqueIntervals = Set(intervals)
        guard intervals.count == uniqueIntervals.count else {
            return .failure(EventError.invalidData("Cannot have duplicate reminder intervals"))
        }
        
        return .success(())
    }
}