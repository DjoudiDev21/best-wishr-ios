import SwiftUI

struct TodaysNotificationsView: View {
    @EnvironmentObject var appStore: AppStore
    
    private var todaysEvents: [Event] {
        appStore.eventsStore.todayEvents
    }
    
    private var upcomingReminders: [Event] {
        appStore.eventsStore.events.filter { event in
            !event.reminders.isEmpty && 
            event.isUpcoming && 
            event.daysUntilEvent <= 3
        }.prefix(3).map { $0 }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Notifications")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Spacer()
                
                if !todaysEvents.isEmpty || !upcomingReminders.isEmpty {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                }
            }
            
            if todaysEvents.isEmpty && upcomingReminders.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("No notifications for today")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(todaysEvents.prefix(2)) { event in
                        NotificationCard(
                            icon: "calendar",
                            title: event.title,
                            message: "Today is \(event.eventType.rawValue.lowercased())",
                            color: event.eventType.color,
                            isToday: true
                        )
                    }
                    
                    ForEach(upcomingReminders.prefix(2)) { event in
                        NotificationCard(
                            icon: "bell",
                            title: event.title,
                            message: "Reminder: \(event.daysUntilEvent) day\(event.daysUntilEvent == 1 ? "" : "s") away",
                            color: Color.orange,
                            isToday: false
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct NotificationCard: View {
    let icon: String
    let title: String
    let message: String
    let color: Color
    let isToday: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(message)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if isToday {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
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
    TodaysNotificationsView()
        .environmentObject(AppStore())
}