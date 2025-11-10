import SwiftUI

struct AppLogoView: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.65, green: 0.3, blue: 0.8),
                            Color(red: 0.75, green: 0.4, blue: 0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 64, height: 64)
                .shadow(color: Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.4), radius: 12, x: 0, y: 4)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Image(systemName: "gift.fill")
                .font(.system(size: 32))
                .foregroundColor(.white)
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)
        }
    }
}

#Preview {
    AppLogoView(isAnimating: .constant(true))
}