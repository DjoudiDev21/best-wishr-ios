import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    let onSearchButtonClicked: (() -> Void)?
    
    init(
        text: Binding<String>,
        placeholder: String = "Search...",
        onSearchButtonClicked: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSearchButtonClicked = onSearchButtonClicked
    }
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                    .font(.system(size: 16, weight: .medium))
                
                TextField(placeholder, text: $text)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                    .onSubmit {
                        onSearchButtonClicked?()
                    }
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.05),
                        Color(red: 0.75, green: 0.4, blue: 0.9).opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.2),
                                Color(red: 0.75, green: 0.4, blue: 0.9).opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SearchBar(
            text: .constant(""),
            placeholder: "Search contacts..."
        )
        
        SearchBar(
            text: .constant("John Doe"),
            placeholder: "Search contacts..."
        )
    }
    .padding()
}