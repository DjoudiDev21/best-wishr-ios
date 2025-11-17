import SwiftUI

struct InlineGiftSuggestionsHeader: View {
    let contactName: String?
    let eventType: EventType
    let hasContent: Bool
    let isLoading: Bool
    let onRefresh: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Gift Suggestions")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                if let contactName = contactName {
                    Text("For \(contactName)'s \(eventType.rawValue)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                } else {
                    Text("For \(eventType.rawValue)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Show loading indicator when generating
            if isLoading {
                HStack(spacing: 6) {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("Updating...")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct InlineGiftSuggestionsContent: View {
    let isLoading: Bool
    let suggestions: [Gift]
    let hasGeneratedOnce: Bool
    let onGenerate: () -> Void
    
    var body: some View {
        if isLoading {
            InlineGiftSuggestionsLoadingState()
        } else if suggestions.isEmpty && hasGeneratedOnce {
            InlineGiftSuggestionsEmptyState(onGenerate: onGenerate)
        } else if suggestions.isEmpty && !hasGeneratedOnce {
            InlineGiftSuggestionsInitialState(onGenerate: onGenerate)
        } else {
            InlineGiftSuggestionsGrid(suggestions: suggestions)
        }
    }
}

struct InlineGiftSuggestionsLoadingState: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(0.8)
                
                Text("Generating suggestions...")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            // Skeleton loading cards
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), 
                spacing: 12
            ) {
                ForEach(0..<4, id: \.self) { _ in
                    SkeletonGiftCard()
                }
            }
        }
    }
}

struct InlineGiftSuggestionsInitialState: View {
    let onGenerate: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.0))
            
            VStack(spacing: 8) {
                Text("Ready to generate gift ideas?")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("AI-powered suggestions based on your event details")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onGenerate) {
                HStack(spacing: 8) {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("Generate Ideas")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
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
        }
        .padding(.vertical, 20)
    }
}

struct InlineGiftSuggestionsEmptyState: View {
    let onGenerate: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("No suggestions found")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Try generating new suggestions or check your event details")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Try Again", action: onGenerate)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .padding(.vertical, 16)
    }
}

struct InlineGiftSuggestionsGrid: View {
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

struct SkeletonGiftCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                // Skeleton icon
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
                
                VStack(spacing: 6) {
                    // Skeleton title
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 14)
                    
                    // Skeleton price
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 60, height: 20)
                }
            }
            
            Divider()
                .opacity(0.2)
            
            // Skeleton button
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 28)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .opacity(isAnimating ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        InlineGiftSuggestionsHeader(
            contactName: "John",
            eventType: .birthday,
            hasContent: true,
            isLoading: false
        ) {
            print("Refresh tapped")
        }
        
        InlineGiftSuggestionsLoadingState()
        
        InlineGiftSuggestionsInitialState {
            print("Generate tapped")
        }
        
        InlineGiftSuggestionsEmptyState {
            print("Try again tapped")
        }
    }
    .padding()
}