import SwiftUI

struct DashboardStatsView: View {
    @EnvironmentObject var appStore: AppStore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Dashboard")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                DashboardStatCard(
                    icon: "person.2.fill",
                    title: "Contacts",
                    value: "\(appStore.contactsStore.contacts.count)",
                    color: Color(red: 0.2, green: 0.6, blue: 0.9)
                )
                
                DashboardStatCard(
                    icon: "calendar.badge.plus",
                    title: "Events",
                    value: "\(appStore.eventsStore.events.count)",
                    color: Color(red: 0.65, green: 0.3, blue: 0.8)
                )
                
                DashboardStatCard(
                    icon: "clock.fill",
                    title: "Upcoming",
                    value: "\(appStore.eventsStore.eventStats.upcomingCount)",
                    color: Color(red: 1.0, green: 0.6, blue: 0.0)
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

struct DashboardStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
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
    DashboardStatsView()
        .environmentObject(AppStore())
}