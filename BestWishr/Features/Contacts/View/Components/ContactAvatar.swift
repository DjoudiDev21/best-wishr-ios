import SwiftUI

struct ContactAvatar: View {
    let firstName: String
    let lastName: String
    let size: CGFloat
    let imageURL: String? = nil
    
    private var initials: String {
        let firstInitial = firstName.prefix(1).uppercased()
        let lastInitial = lastName.prefix(1).uppercased()
        return "\(firstInitial)\(lastInitial)"
    }
    
    private var backgroundColor: Color {
        // Generate consistent color based on name
        let hash = abs("\(firstName)\(lastName)".hashValue)
        let colors = [
            Color(red: 0.65, green: 0.3, blue: 0.8),
            Color(red: 0.75, green: 0.4, blue: 0.9),
            Color(red: 0.85, green: 0.5, blue: 0.7),
            Color(red: 0.7, green: 0.35, blue: 0.75),
            Color(red: 0.6, green: 0.25, blue: 0.85)
        ]
        return colors[hash % colors.count]
    }
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        backgroundColor,
                        backgroundColor.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay(
                Text(initials)
                    .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            ContactAvatar(firstName: "John", lastName: "Doe", size: 40)
            ContactAvatar(firstName: "Jane", lastName: "Smith", size: 50)
            ContactAvatar(firstName: "Mike", lastName: "Johnson", size: 60)
        }
        
        HStack(spacing: 16) {
            ContactAvatar(firstName: "Sarah", lastName: "Wilson", size: 80)
            ContactAvatar(firstName: "David", lastName: "Brown", size: 100)
        }
    }
    .padding()
}