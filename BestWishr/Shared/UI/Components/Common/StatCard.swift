import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
            
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [
                    color.opacity(0.05),
                    color.opacity(0.02)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}

#Preview {
    HStack(spacing: 16) {
        StatCard(
            title: "Total",
            value: "24",
            icon: "person.3.fill",
            color: Color(red: 0.65, green: 0.3, blue: 0.8)
        )
        
        StatCard(
            title: "This Month",
            value: "3",
            icon: "calendar",
            color: Color(red: 0.75, green: 0.4, blue: 0.9)
        )
    }
    .padding()
}