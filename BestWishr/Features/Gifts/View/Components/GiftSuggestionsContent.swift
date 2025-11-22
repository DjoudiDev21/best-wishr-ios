import SwiftUI

struct GiftSuggestionsContent: View {
    let isLoading: Bool
    let suggestions: [Gift]
    let onGenerate: () -> Void
    
    var body: some View {
        if isLoading {
            GiftSuggestionsLoadingState()
        } else if suggestions.isEmpty {
            GiftSuggestionsEmptyState(onGenerate: onGenerate)
        } else {
            GiftSuggestionsGrid(suggestions: suggestions)
        }
    }
}

struct GiftSuggestionsLoadingState: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Generating gift suggestions...")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(height: 120)
    }
}

struct GiftSuggestionsEmptyState: View {
    let onGenerate: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "gift")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.secondary)
            
            Text("No suggestions generated yet")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            Button("Generate Suggestions", action: onGenerate)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
        }
        .frame(height: 120)
    }
}

struct GiftSuggestionsGrid: View {
    let suggestions: [Gift]
    
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), 
            spacing: 12
        ) {
            ForEach(suggestions.prefix(4)) { gift in
                GiftSuggestionCard(gift: gift)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        GiftSuggestionsLoadingState()
        
        GiftSuggestionsEmptyState { }
    }
    .padding()
}
