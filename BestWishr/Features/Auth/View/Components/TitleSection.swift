import SwiftUI

struct TitleSection: View {
    var body: some View {
        VStack(spacing: 4) {
            Text("Célébrations")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.65, green: 0.3, blue: 0.8),
                            Color(red: 0.75, green: 0.4, blue: 0.9)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("Never miss a special moment")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
        }
    }
}

#Preview {
    TitleSection()
}