import Foundation

class GenerateGeneralGiftSuggestionsUseCase {
    private let repository: GiftRepository
    
    init(repository: GiftRepository) {
        self.repository = repository
    }
    
    func execute(for eventType: EventType, ageGroup: AgeGroup? = nil, gender: String? = nil) async throws -> [Gift] {
        return try await repository.generateGeneralSuggestions(eventType: eventType, ageGroup: ageGroup, gender: gender)
    }
}