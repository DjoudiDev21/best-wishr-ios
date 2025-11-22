import SwiftUI

struct SocialLoginButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.93, green: 0.92, blue: 0.95), lineWidth: 1)
                )
        }
    }
}

#Preview {
    HStack(spacing: 10) {
        SocialLoginButton(icon: "globe") { }
        
        SocialLoginButton(icon: "applelogo") { }
    }
    .padding()
}
