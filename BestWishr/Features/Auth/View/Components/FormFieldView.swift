import SwiftUI

struct FormFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var trailingButton: FormFieldTrailingButton? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Spacer()
                
                if let trailingButton = trailingButton {
                    Button(trailingButton.title) {
                        trailingButton.action()
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                }
            }
            
            InputField(
                placeholder: placeholder,
                text: $text,
                isSecure: isSecure
            )
        }
    }
}

struct FormFieldTrailingButton {
    let title: String
    let action: () -> Void
}

#Preview {
    VStack(spacing: 20) {
        FormFieldView(
            title: "Email",
            placeholder: "you@example.com",
            text: .constant("")
        )
        
        FormFieldView(
            title: "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            isSecure: true,
            trailingButton: FormFieldTrailingButton(
                title: "Forgot?",
                action: { print("Forgot password tapped") }
            )
        )
    }
    .padding()
}