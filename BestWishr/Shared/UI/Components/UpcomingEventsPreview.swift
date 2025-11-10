import SwiftUI

struct UpcomingEventsPreview: View {
    @EnvironmentObject var appStore: AppStore
    
    private var upcomingEvents: [Event] {
        let calendar = Calendar.current
        let thirtyDaysFromNow = calendar.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        
        return appStore.eventsStore.events
            .filter { event in
                event.isUpcoming && event.date <= thirtyDaysFromNow
            }
            .sorted { $0.date < $1.date }
            .prefix(4)
            .map { $0 }
    }
    
    private func contactName(for event: Event) -> String? {
        guard let contactId = event.contactId else { return nil }
        let contact = appStore.contactsStore.contacts.first { $0.id == contactId }
        return contact?.fullName
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Upcoming Events")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Spacer()
                
                if !upcomingEvents.isEmpty {
                    NavigationLink(destination: Text("Events Screen")) {
                        HStack(spacing: 4) {
                            Text("View All")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                        }
                    }
                }
            }
            
            if upcomingEvents.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("No upcoming events in the next 30 days")
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
                    ForEach(upcomingEvents) { event in
                        UpcomingEventRow(
                            event: event,
                            contactName: contactName(for: event)
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct UpcomingEventRow: View {
    let event: Event
    let contactName: String?
    
    var body: some View {
        HStack(spacing: 12) {
            // Date
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: event.date))")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(event.eventType.color)
                
                Text(event.shortFormattedDate.components(separatedBy: " ").dropFirst().joined(separator: " "))
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .frame(width: 40)
            
            // Event type icon
            ZStack {
                Circle()
                    .fill(event.eventType.color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: event.eventType.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(event.eventType.color)
            }
            
            // Event details
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    if let contactName = contactName {
                        HStack(spacing: 2) {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            
                            Text(contactName)
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    } else {
                        Text(event.eventType.rawValue)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            // Days until
            VStack(spacing: 1) {
                if event.isToday {
                    Text("Today")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(event.eventType.color)
                } else {
                    Text("\(event.daysUntilEvent)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("day\(event.daysUntilEvent == 1 ? "" : "s")")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(event.eventType.color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    UpcomingEventsPreview()
        .environmentObject(AppStore())
}