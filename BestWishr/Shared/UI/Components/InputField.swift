import SwiftUI
#if os(iOS)
import UIKit
#endif

enum InputType {
    case text
    case email
    case phone
    case number
    
    #if os(iOS)
    var keyboardType: UIKeyboardType {
        switch self {
        case .text:
            return .default
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        case .number:
            return .numberPad
        }
    }
    
    var textContentType: UITextContentType? {
        switch self {
        case .text:
            return nil
        case .email:
            return .emailAddress
        case .phone:
            return .telephoneNumber
        case .number:
            return nil
        }
    }
    #endif
    
    #if os(iOS)
    var autocapitalizationType: UITextAutocapitalizationType {
        switch self {
        case .text:
            return .sentences
        case .email:
            return .none
        case .phone:
            return .none
        case .number:
            return .none
        }
    }
    #endif
}

struct InputField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var inputType: InputType = .text
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        HStack {
            Group {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(CompactTextFieldStyle())
                } else {
                    #if os(iOS)
                    TextField(placeholder, text: $text)
                        .textFieldStyle(CompactTextFieldStyle())
                        .keyboardType(inputType.keyboardType)
                        .textContentType(inputType.textContentType)
                        .autocapitalization(inputType.autocapitalizationType)
                    #else
                    TextField(placeholder, text: $text)
                        .textFieldStyle(CompactTextFieldStyle())
                    #endif
                }
            }
            
            if isSecure {
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .font(.system(size: 16))
                }
                .padding(.trailing, 12)
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