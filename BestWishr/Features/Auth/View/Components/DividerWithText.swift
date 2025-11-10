import SwiftUI

struct DividerWithText: View {
    let text: String
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(red: 0.93, green: 0.92, blue: 0.95))
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                .padding(.horizontal, 12)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(red: 0.93, green: 0.92, blue: 0.95))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DividerWithText(text: "Or continue with")
        DividerWithText(text: "Or")
        DividerWithText(text: "Already have an account?")
    }
    .padding()
}