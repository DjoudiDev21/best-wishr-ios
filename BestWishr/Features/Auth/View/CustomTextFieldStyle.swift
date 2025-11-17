import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            .accentColor(Color(red: 0.65, green: 0.3, blue: 0.8))
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: isFocused ? Color.purple.opacity(0.3) : Color.black.opacity(0.1), 
                           radius: isFocused ? 8 : 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: isFocused ? [Color.purple, Color.pink] : [Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: isFocused ? 2 : 0
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .focused($isFocused)
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 16))
            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            .accentColor(Color(red: 0.65, green: 0.3, blue: 0.8))
            .padding(16)
            .background(Color(red: 0.97, green: 0.96, blue: 0.98))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isFocused ? Color(red: 0.65, green: 0.3, blue: 0.8) : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(
                color: isFocused ? Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.2) : Color.clear,
                radius: isFocused ? 8 : 0,
                x: 0,
                y: 2
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .focused($isFocused)
    }
}

struct CompactTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 14))
            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            .accentColor(Color(red: 0.65, green: 0.3, blue: 0.8))
            .padding(12)
            .background(Color(red: 0.97, green: 0.96, blue: 0.98))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color(red: 0.65, green: 0.3, blue: 0.8) : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(
                color: isFocused ? Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.2) : Color.clear,
                radius: isFocused ? 4 : 0,
                x: 0,
                y: 1
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .focused($isFocused)
    }
}