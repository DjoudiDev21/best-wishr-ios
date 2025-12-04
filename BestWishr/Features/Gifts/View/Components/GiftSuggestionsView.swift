import SwiftUI

struct GiftSuggestionsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appStore: AppStore
    @State private var viewModel: GiftSuggestionsViewModel?
    let contactId: String?
    let eventType: EventType
    
    private var contactName: String? {
        guard let contactId = contactId else { return nil }
        return appStore.contactsStore.contacts.first { $0.id == contactId }?.fullName
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let viewModel = viewModel {
                    GiftSuggestionsHeader(
                        contactName: contactName,
                        eventType: eventType,
                        hasContent: !viewModel.suggestions.isEmpty
                    ) {
                        viewModel.showingAllSuggestions = true
                    }
                    
                    GiftSuggestionsContent(
                        isLoading: viewModel.isLoading,
                        suggestions: viewModel.suggestions
                    ) {
                        Task {
                            await viewModel.generateSuggestions(contactId: contactId, eventType: eventType)
                        }
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
                await viewModel?.generateSuggestions(contactId: contactId, eventType: eventType)
            }
        }
        .sheet(isPresented: Binding(
            get: { viewModel?.showingAllSuggestions ?? false },
            set: { viewModel?.showingAllSuggestions = $0 }
        )) {
            AllGiftSuggestionsView(contactId: contactId, type: eventType)
        }
    }
}

#Preview {
    GiftSuggestionsView(contactId: "1", eventType: .birthday)
        .environmentObject(AppStore())
}
