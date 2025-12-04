import SwiftUI

struct AllGiftSuggestionsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appStore: AppStore
    let contactId: String?
    let type: EventType
    
    private var contactName: String? {
        guard let contactId = contactId else { return nil }
        return appStore.contactsStore.contacts.first { $0.id == contactId }?.fullName
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(appStore.giftsStore.suggestions) { gift in
                        GiftSuggestionCard(gift: gift)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Gift Suggestions")
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
    }
}

#Preview {
    AllGiftSuggestionsView(contactId: "1", type: .birthday)
        .environmentObject(AppStore())
}
