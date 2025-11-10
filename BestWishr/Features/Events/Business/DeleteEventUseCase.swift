import Foundation

struct DeleteEventUseCase {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(eventId: String) async -> Result<Void, Error> {
        do {
            // Verify event exists before deleting
            guard let _ = try await repository.getEvent(id: eventId) else {
                return .failure(EventError.notFound)
            }
            
            // Delete the event
            try await repository.deleteEvent(id: eventId)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}