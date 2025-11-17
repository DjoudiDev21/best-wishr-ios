import SwiftUI

struct TermsAndConditionsView: View {
    @Binding var agreeToTerms: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: {
                agreeToTerms.toggle()
            }) {
                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                    .foregroundColor(agreeToTerms ? Color(red: 0.65, green: 0.3, blue: 0.8) : .gray)
                    .font(.title3)
            }
            
            Text("I agree to the **Terms of Service** and **Privacy Policy**")
                .font(.caption)
                .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
        }
        .padding(.top, 8)
    }
}

#Preview {
    VStack(spacing: 20) {
        TermsAndConditionsView(agreeToTerms: .constant(false))
        TermsAndConditionsView(agreeToTerms: .constant(true))
    }
    .padding()
}