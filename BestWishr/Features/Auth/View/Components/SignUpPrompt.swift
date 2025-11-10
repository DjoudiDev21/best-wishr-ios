import SwiftUI

struct SignUpPrompt: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text("Don't have an account?")
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
            
            Button("Sign up") {
                action()
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
        }
    }
}

#Preview {
    SignUpPrompt {
        print("Sign up tapped")
    }
    .padding()
}