import Foundation

class GeneratePersonalizedGiftSuggestionsUseCase {
    private let repository: GiftRepository
    
    init(repository: GiftRepository) {
        self.repository = repository
    }
    
    func execute(for contactId: String, eventType: EventType) async throws -> [Gift] {
        return try await repository.generateSuggestions(contactId: contactId, eventType: eventType)
    }
}