import Foundation

class GenerateGiftSuggestionsUseCase {
    private let repository: GiftRepositoryProtocol
    
    init(repository: GiftRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(from eventData: EventCreationData, preferences: [String]? = nil, maxSuggestions: Int? = 5) async throws -> [Gift] {
        do {
            let suggestions = try await repository.generateSuggestions(
                from: eventData,
                preferences: preferences,
                maxSuggestions: maxSuggestions
            )
            
            // Log success for analytics
            print("✅ Generated \(suggestions.count) gift suggestions for event type: \(eventData.type)")
            
            return suggestions
        } catch {
            print("❌ Failed to generate gift suggestions for event type: \(eventData.type), error: \(error)")
            throw error
        }
    }
}