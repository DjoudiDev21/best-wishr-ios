import SwiftUI

struct AddEventScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appStore: AppStore
    @State private var eventData = EventCreationData()
    @State private var showingGiftSuggestions = false
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Form Header
                    AddEventHeader()
                    
                    // Event Form
                    AddEventForm(eventData: $eventData)
                    
                    // Gift Suggestions Section
                    if eventData.isValid {
                        AddEventGiftSuggestionsSection(
                            eventData: eventData,
                            showingGiftSuggestions: $showingGiftSuggestions
                        )
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    Task {
                        await saveEvent()
                    }
                }
                .disabled(!eventData.isValid || isSubmitting)
            )
        }
        .sheet(isPresented: $showingGiftSuggestions) {
            if eventData.contactId != nil {
                GiftSuggestionsView(contactId: eventData.contactId, eventType: eventData.eventType)
            } else {
                GiftSuggestionsView(contactId: nil, eventType: eventData.eventType)
            }
        }
    }
    
    private func saveEvent() async {
        isSubmitting = true
        
        let success = await appStore.eventsStore.createEvent(eventData)
        
        if success {
            dismiss()
        }
        // Error handling is done by EventsStore and GlobalErrorHandler
        
        isSubmitting = false
    }
}

struct AddEventHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
            
            VStack(spacing: 4) {
                Text("Create New Event")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Text("Plan your celebrations and important dates")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    AddEventScreen()
        .environmentObject(AppStore())
}