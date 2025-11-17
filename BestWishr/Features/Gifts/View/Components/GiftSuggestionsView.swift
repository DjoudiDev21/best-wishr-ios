import SwiftUI

struct GiftSuggestionsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appStore: AppStore
    let contactId: String?
    let eventType: EventType
    @State private var showingAllSuggestions = false
    
    private var contactName: String? {
        guard let contactId = contactId else { return nil }
        return appStore.contactsStore.contacts.first { $0.id == contactId }?.fullName
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .navigationTitle("Gift Ideas")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            #endif
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
