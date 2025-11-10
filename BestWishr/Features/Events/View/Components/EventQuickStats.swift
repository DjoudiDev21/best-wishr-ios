import SwiftUI

struct EventQuickStats: View {
    let stats: EventStats
    
    var body: some View {
        HStack(spacing: 16) {
            // Total events
            EventStatCard(
                title: "Total",
                value: "\(stats.totalCount)",
                icon: "calendar",
                color: Color(red: 0.65, green: 0.3, blue: 0.8)
            )
            
            // Upcoming events
            EventStatCard(
                title: "Upcoming",
                value: "\(stats.upcomingCount)",
                icon: "clock",
                color: Color(red: 0.2, green: 0.6, blue: 0.9)
            )
            
            // Today's events
            EventStatCard(
                title: "Today",
                value: "\(stats.todayCount)",
                icon: "sun.max",
                color: Color(red: 1.0, green: 0.6, blue: 0.0)
            )
            
            // Completed events
            EventStatCard(
                title: "Done",
                value: "\(stats.completedCount)",
                icon: "checkmark.circle",
                color: Color(red: 0.4, green: 0.8, blue: 0.4)
            )
        }
    }
}

struct EventStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }
            
            // Value and title
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    EventQuickStats(
        stats: EventStats(
            totalCount: 12,
            upcomingCount: 8,
            todayCount: 2,
            completedCount: 4
        )
    )
    .padding()
}