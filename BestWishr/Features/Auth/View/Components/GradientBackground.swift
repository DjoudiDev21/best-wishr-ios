import SwiftUI

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.92, green: 0.89, blue: 0.98), // Light lavender
                Color(red: 0.95, green: 0.92, blue: 0.99), // Very light pink
                Color(red: 0.97, green: 0.95, blue: 0.98)  // Almost white with warmth
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GradientBackground()
}