import SwiftUI

struct InputField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(CompactTextFieldStyle())
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(CompactTextFieldStyle())
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        InputField(
            placeholder: "Enter your email",
            text: .constant("")
        )
        
        InputField(
            placeholder: "Enter your password",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding()
}