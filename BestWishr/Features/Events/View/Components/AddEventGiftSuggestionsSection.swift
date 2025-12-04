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
        lastEventType != eventData.type || lastContactId != eventData.contactId
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            GiftSuggestionsHeaderToggle(
                eventData: $eventData
            )
            
            // Generate button + info
            GenerateButtonSection(
                eventData: eventData,
                hasGeneratedOnce: hasGeneratedOnce,
                contactName: contactName,
                isLoading: appStore.giftsStore.isLoadingSuggestions,
                generate: generateSuggestions
            )
            
            // Inline suggestions
            SuggestionsSection(
                eventData: eventData,
                contactName: contactName,
                shouldRegenerateContent: shouldRegenerateContent,
                hasGeneratedOnce: hasGeneratedOnce,
                suggestions: appStore.giftsStore.suggestions,
                isLoading: appStore.giftsStore.isLoadingSuggestions,
                regenerate: generateSuggestions
            )
        }
        .padding(16)
        .giftBoxBackground()
        .onChange(of: eventData.giftSuggestionsEnabled) { _, enabled in
            if !enabled {
                appStore.giftsStore.clearSuggestions()
                hasGeneratedOnce = false
                lastEventType = nil
                lastContactId = nil
            }
        }
    }
    
    private func generateSuggestions() async {
        lastEventType = eventData.type
        lastContactId = eventData.contactId
        hasGeneratedOnce = true
        
        // Use the new form-based approach that doesn't require an existing event
        await appStore.giftsStore.generateSuggestions(from: eventData)
    }
}

struct GiftSuggestionsHeaderToggle: View {
    @Binding var eventData: EventCreationData
    
    var body: some View {
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
    }
}

struct GenerateButtonSection: View {
    let eventData: EventCreationData
    let hasGeneratedOnce: Bool
    let contactName: String?
    let isLoading: Bool
    let generate: () async -> Void
    
    var body: some View {
        if eventData.giftSuggestionsEnabled && !hasGeneratedOnce && !isLoading {
            VStack(spacing: 12) {
                
                Button(action: {
                    Task { await generate() }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                        Text("Generate Gift Ideas")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: eventData.canGenerateGiftSuggestions ? 
                                        [Color(red: 1.0, green: 0.6, blue: 0.0), Color(red: 1.0, green: 0.5, blue: 0.2)] :
                                        [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                    )
                }
                .disabled(!eventData.canGenerateGiftSuggestions)
                
                if !eventData.canGenerateGiftSuggestions {
                    InfoBubble(icon: "exclamationmark.triangle",
                               text: "Please add an event title to generate gift suggestions",
                               color: Color.red)
                } else if eventData.contactId == nil {
                    InfoBubble(icon: "info.circle",
                               text: "Add a contact above for personalized suggestions",
                               color: Color.orange)
                } else {
                    InfoBubble(icon: "person.circle.fill",
                               text: "Will generate personalized suggestions for \(contactName ?? "selected contact")",
                               color: Color.blue)
                }
            }
        }
    }
}

struct SuggestionsSection: View {
    let eventData: EventCreationData
    let contactName: String?
    let shouldRegenerateContent: Bool
    let hasGeneratedOnce: Bool
    let suggestions: [Gift]
    let isLoading: Bool
    let regenerate: () async -> Void
    
    var body: some View {
        if !eventData.giftSuggestionsEnabled { return AnyView(EmptyView()) }
        
        if isLoading {
            return AnyView(InlineGiftSuggestionsLoadingState())
        }
        
        if !suggestions.isEmpty {
            return AnyView(
                VStack(spacing: 12) {
                    header
                    if shouldRegenerateContent { refreshWarning }
                    InlineGiftSuggestionsGrid(suggestions: suggestions)
                }
            )
        }
        
        if hasGeneratedOnce {
            return AnyView(
                InlineGiftSuggestionsEmptyState {
                    Task { await regenerate() }
                }
            )
        }
        
        return AnyView(EmptyView())
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                if let name = contactName {
                    Text("For \(name)'s \(eventData.type.rawValue)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } else {
                    Text("For \(eventData.type.rawValue)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                
                Text("\(suggestions.count) suggestions")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { Task { await regenerate() } }) {
                if shouldRegenerateContent {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                        Text("Update")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange)
                    )
                } else {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var refreshWarning: some View {
        InfoBubble(
            icon: "exclamationmark.triangle.fill",
            text: "Tap 'Update' to generate new suggestions for this context",
            color: .orange,
            small: true
        )
    }
}

struct InfoBubble: View {
    let icon: String
    let text: String
    let color: Color
    var small: Bool = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: small ? 10 : 12))
            Text(text)
                .font(.system(size: small ? 11 : 12, weight: .medium, design: .rounded))
        }
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, small ? 6 : 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.2), lineWidth: 1))
        )
    }
}

extension View {
    func giftBoxBackground() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

