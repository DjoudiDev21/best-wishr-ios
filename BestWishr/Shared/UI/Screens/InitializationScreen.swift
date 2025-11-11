import SwiftUI

struct InitializationScreen: View {
    @EnvironmentObject var appStore: AppStore
    @State private var isAnimating = true
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // App Logo
            VStack(spacing: 16) {
                AppLogoView(isAnimating: $isAnimating)
                
                Text("BestWishr")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
            }
            
            Spacer()
            
            // Loading indicator and message
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.45, green: 0.3, blue: 0.6)))
                    .scaleEffect(1.2)
                
                Text("Loading your data...")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color(red: 0.95, green: 0.95, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    InitializationScreen()
        .environmentObject(AppStore())
}