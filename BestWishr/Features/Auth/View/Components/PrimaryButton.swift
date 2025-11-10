import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                LinearGradient(
                    colors: isDisabled ? 
                    [Color.gray.opacity(0.3), Color.gray.opacity(0.3)] :
                    [Color(red: 0.65, green: 0.3, blue: 0.8), Color(red: 0.75, green: 0.4, blue: 0.9)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: isDisabled ? .clear : Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .disabled(isDisabled || isLoading)
        .scaleEffect(isDisabled ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(
            title: "Sign In",
            action: { print("Sign In tapped") }
        )
        
        PrimaryButton(
            title: "Loading...",
            action: { },
            isLoading: true
        )
        
        PrimaryButton(
            title: "Disabled",
            action: { },
            isDisabled: true
        )
    }
    .padding()
}