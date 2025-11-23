import SwiftUI

struct FormFieldView<FocusValue: Hashable>: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var inputType: InputType = .text
    var trailingButton: FormFieldTrailingButton? = nil
    var focusBinding: FocusState<FocusValue?>.Binding?
    var focusValue: FocusValue?
    
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
            
            InputField<FocusValue>(
                placeholder: placeholder,
                text: $text,
                isSecure: isSecure,
                inputType: inputType,
                focusBinding: focusBinding,
                focusValue: focusValue
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
        FormFieldView<String>(
            title: "Email",
            placeholder: "you@example.com",
            text: .constant(""),
            inputType: .email
        )
        
        FormFieldView<String>(
            title: "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            isSecure: true,
            trailingButton: FormFieldTrailingButton(
                title: "Forgot?",
                action: { }
            )
        )
    }
    .padding()
}
