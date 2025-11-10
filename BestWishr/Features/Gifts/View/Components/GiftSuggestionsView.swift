import SwiftUI

struct GiftSuggestionsView: View {
    @EnvironmentObject var appStore: AppStore
    let contactId: String?
    let eventType: EventType
    @State private var showingAllSuggestions = false
    
    private var contactName: String? {
        guard let contactId = contactId else { return nil }
        return appStore.contactsStore.contacts.first { $0.id == contactId }?.fullName
    }
    
    var body: some View {
        VStack(spacing: 16) {
            GiftSuggestionsHeader(
                contactName: contactName,
                eventType: eventType,
                hasContent: !appStore.giftsStore.suggestions.isEmpty
            ) {
                showingAllSuggestions = true
            }
            
            GiftSuggestionsContent(
                isLoading: appStore.giftsStore.isLoadingSuggestions,
                suggestions: appStore.giftsStore.suggestions
            ) {
                Task {
                    await generateSuggestions()
                }
            }
        }
        .onAppear {
            Task {
                await generateSuggestions()
            }
        }
        .sheet(isPresented: $showingAllSuggestions) {
            AllGiftSuggestionsView(contactId: contactId, eventType: eventType)
        }
    }
    
    private func generateSuggestions() async {
        if let contactId = contactId {
            await appStore.giftsStore.generatePersonalizedSuggestions(for: contactId, eventType: eventType)
        } else {
            await appStore.giftsStore.generateGeneralSuggestions(for: eventType)
        }
    }
}

#Preview {
    GiftSuggestionsView(contactId: "1", eventType: .birthday)
        .environmentObject(AppStore())
}