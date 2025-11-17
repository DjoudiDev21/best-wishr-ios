import SwiftUI

struct AddEventGiftSuggestionsSection: View {
    @EnvironmentObject var appStore: AppStore
    @Binding var eventData: EventCreationData
    @Binding var showingGiftSuggestions: Bool
    @State private var lastEventType: EventType? = nil
    @State private var lastContactId: String? = nil
    @State private var hasGeneratedOnce = false
    
    private var contactName: String? {
        guard let contactId = eventData.contactId else { return nil }
        return appStore.contactsStore.contacts.first { $0.id == contactId }?.fullName
    }
    
    private var shouldRegenerateContent: Bool {
        lastEventType != eventData.eventType || lastContactId != eventData.contactId
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Gift Suggestions Toggle Section
            VStack(spacing: 16) {
                // Section Header with Toggle
                HStack(spacing: 12) {
                    Image(systemName: "gift")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.0))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Gift Suggestions")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                        
                        Text("Get AI-powered gift ideas")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $eventData.giftSuggestionsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 1.0, green: 0.6, blue: 0.0)))
                }
                
                // Generate Button (only when enabled but not generated yet)
                if eventData.giftSuggestionsEnabled && !hasGeneratedOnce && !appStore.giftsStore.isLoadingSuggestions {
                    VStack(spacing: 12) {
                        Button(action: {
                            Task {
                                await generateSuggestions()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "wand.and.stars")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Text("Generate Gift Ideas")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 1.0, green: 0.6, blue: 0.0), Color(red: 1.0, green: 0.5, blue: 0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        
                        // Helpful info based on contact selection
                        if eventData.contactId == nil {
                            HStack(spacing: 6) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 12, weight: .medium))
                                Text("Add a contact above for personalized suggestions")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.0))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.2), lineWidth: 1)
                                    )
                            )
                        } else {
                            HStack(spacing: 6) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 12, weight: .medium))
                                Text("Will generate personalized suggestions for \(contactName ?? "selected contact")")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.2, green: 0.6, blue: 0.9).opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0.2, green: 0.6, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                
                // Inline Gift Suggestions (only when enabled)
                if eventData.giftSuggestionsEnabled {
                    if appStore.giftsStore.isLoadingSuggestions {
                        InlineGiftSuggestionsLoadingState()
                    } else if !appStore.giftsStore.suggestions.isEmpty {
                        VStack(spacing: 12) {
                            // Results Header with Regenerate Option
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    if let contactName = contactName {
                                        Text("For \(contactName)'s \(eventData.eventType.rawValue)")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(.primary)
                                    } else {
                                        Text("For \(eventData.eventType.rawValue)")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Text("\(appStore.giftsStore.suggestions.count) suggestions")
                                        .font(.system(size: 12, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                // Regenerate button when context has changed
                                if shouldRegenerateContent {
                                    Button(action: {
                                        Task {
                                            await generateSuggestions()
                                        }
                                    }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "arrow.clockwise")
                                                .font(.system(size: 12, weight: .medium))
                                            Text("Update")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color(red: 1.0, green: 0.6, blue: 0.0))
                                                .shadow(color: Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.3), radius: 4, x: 0, y: 2)
                                        )
                                    }
                                } else {
                                    // Subtle refresh option when no context change
                                    Button(action: {
                                        Task {
                                            await generateSuggestions()
                                        }
                                    }) {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            
                            // Context change notification
                            if shouldRegenerateContent {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 10, weight: .medium))
                                    Text("Tap 'Update' to generate new suggestions for this context")
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(.orange)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.orange.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            
                            // Gift Grid
                            InlineGiftSuggestionsGrid(suggestions: appStore.giftsStore.suggestions)
                        }
                    } else if hasGeneratedOnce {
                        InlineGiftSuggestionsEmptyState {
                            Task {
                                await generateSuggestions()
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.2), lineWidth: 1)
                )
        )
        .onChange(of: eventData.giftSuggestionsEnabled) { _, enabled in
            if !enabled {
                // Clear suggestions when disabled
                appStore.giftsStore.clearSuggestions()
                hasGeneratedOnce = false
                lastEventType = nil
                lastContactId = nil
            }
        }
    }
    
    private func handleContentChange() {
        if shouldRegenerateContent {
            // Clear existing suggestions immediately
            appStore.giftsStore.clearSuggestions()
            hasGeneratedOnce = false
            
            // Generate new suggestions
            Task {
                await generateSuggestions()
            }
        }
    }
    
    private func generateSuggestions() async {
        lastEventType = eventData.eventType
        lastContactId = eventData.contactId
        hasGeneratedOnce = true
        
        if let contactId = eventData.contactId {
            await appStore.giftsStore.generatePersonalizedSuggestions(for: contactId, eventType: eventData.eventType)
        } else {
            await appStore.giftsStore.generateGeneralSuggestions(for: eventData.eventType)
        }
    }
}

struct GiftSuggestionBenefit: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.0))
                .frame(width: 16)
            
            Text(text)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    VStack {
        AddEventGiftSuggestionsSection(
            eventData: .constant(EventCreationData(
                title: "John's Birthday",
                eventType: .birthday,
                contactId: "1"
            )),
            showingGiftSuggestions: .constant(false)
        )
        
        AddEventGiftSuggestionsSection(
            eventData: .constant(EventCreationData(
                title: "Anniversary Dinner",
                eventType: .anniversary
            )),
            showingGiftSuggestions: .constant(false)
        )
    }
    .padding()
    .environmentObject(AppStore())
}
