import SwiftUI

struct FloatingIconsBackground: View {
    @Binding var isAnimating: Bool
    @Binding var showFloatingIcons: Bool
    
    private let icons = ["gift.fill", "sparkles", "heart.fill", "party.popper.fill", "star.fill", "balloon.fill"]
    private let sizes: [CGFloat] = [32, 24, 20, 36, 16, 28]
    private let opacities: [Double] = [0.2, 0.3, 0.2, 0.25, 0.3, 0.2]
    private let xPositions: [CGFloat] = [60, 320, 100, 280, 340, 140]
    private let yPositions: [CGFloat] = [120, 200, 480, 560, 320, 680]
    private let rotations: [Double] = [10, -15, 8, -12, 20, -8]
    private let durations: [Double] = [3.0, 2.5, 4.0, 3.5, 2.8, 3.2]
    
    var body: some View {
        ForEach(0..<6, id: \.self) { index in
            Image(systemName: icons[index])
                .font(.system(size: sizes[index]))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8).opacity(opacities[index]))
                .position(x: xPositions[index], y: yPositions[index])
                .opacity(showFloatingIcons ? 1 : 0)
                .scaleEffect(showFloatingIcons ? 1 : 0.5)
                .rotationEffect(.degrees(isAnimating ? rotations[index] : 0))
                .animation(
                    .easeInOut(duration: durations[index])
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.3),
                    value: isAnimating
                )
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1)
            .ignoresSafeArea()
        
        FloatingIconsBackground(
            isAnimating: .constant(true),
            showFloatingIcons: .constant(true)
        )
    }
}