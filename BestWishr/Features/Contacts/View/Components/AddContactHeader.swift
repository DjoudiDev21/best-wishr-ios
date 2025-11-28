import SwiftUI

struct AddContactHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
            
            VStack(spacing: 4) {
                Text("Add New Contact")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Text("Keep track of important people in your life")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    AddContactHeader()
}