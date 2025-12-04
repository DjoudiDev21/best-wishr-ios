import Foundation
import SwiftUI
import Combine

@MainActor
final class GiftSuggestionsViewModel: ObservableObject {
    @Published var showingAllSuggestions = false
    @Published var isLoading = false
    @Published var suggestions: [Gift] = []
    @Published var error: String?
    
    private let giftsStore: GiftsStore
    private var cancellables = Set<AnyCancellable>()
    
    init(giftsStore: GiftsStore) {
        self.giftsStore = giftsStore
        setupBindings()
    }
    
    private func setupBindings() {
        giftsStore.$suggestions
            .receive(on: DispatchQueue.main)
            .assign(to: \.suggestions, on: self)
            .store(in: &cancellables)
        
        giftsStore.$isLoadingSuggestions
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        giftsStore.$error
            .receive(on: DispatchQueue.main)
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }
    
    func generateSuggestions(contactId: String?, eventType: EventType) async {
        var eventData = EventCreationData()
        eventData.title = "\(eventType.rawValue) Gift Ideas"
        eventData.type = eventType
        eventData.date = Date()
        eventData.contactId = contactId
        eventData.description = ""
        eventData.isRecurring = false
        
        await giftsStore.generateSuggestions(from: eventData)
    }
    
    func clearSuggestions() {
        suggestions = []
    }
    
    func clearError() {
        error = nil
    }
    
    func saveToWishlist(_ gift: Gift) async {
        do {
            print("save to whishlist")
        } catch {
            self.error = "Failed to save gift: \(error.localizedDescription)"
        }
    }
}
