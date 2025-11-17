import SwiftUI

struct PasswordRequirementsView: View {
    let password: String
    
    var body: some View {
        if !password.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("Password must contain:")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                HStack {
                    Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(password.count >= 6 ? .green : .gray)
                        .font(.caption)
                    Text("At least 6 characters")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                }
            }
            .padding(.top, 4)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PasswordRequirementsView(password: "")
        PasswordRequirementsView(password: "123")
        PasswordRequirementsView(password: "123456")
    }
    .padding()
}