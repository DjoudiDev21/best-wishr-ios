import SwiftUI

struct EventCard: View {
    let event: Event
    let contactName: String? // Contact name if event is linked to a contact
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Event type icon and date
                VStack(spacing: 8) {
                    // Event type icon
                    ZStack {
                        Circle()
                            .fill(event.eventType.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: event.eventType.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(event.eventType.color)
                    }
                    
                    // Date info
                    VStack(spacing: 2) {
                        Text(event.shortFormattedDate)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        if event.isToday {
                            Text("Today")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(event.eventType.color)
                        } else if event.isUpcoming && event.daysUntilEvent <= 7 {
                            Text("\(event.daysUntilEvent)d")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                // Event details
                VStack(alignment: .leading, spacing: 8) {
                    // Title and contact
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        if let contactName = contactName {
                            HStack(spacing: 4) {
                                Image(systemName: "person.crop.circle")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                
                                Text(contactName)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Event type and description
                    HStack(spacing: 8) {
                        // Event type badge
                        HStack(spacing: 4) {
                            Circle()
                                .fill(event.eventType.color)
                                .frame(width: 8, height: 8)
                            
                            Text(event.eventType.rawValue)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(event.eventType.color)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(event.eventType.color.opacity(0.1))
                        .cornerRadius(12)
                        
                        Spacer()
                        
                        // Status indicators
                        HStack(spacing: 6) {
                            // Recurring indicator
                            if event.recurrence != nil {
                                Image(systemName: "repeat")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            // Reminders indicator
                            if !event.reminders.isEmpty {
                                Image(systemName: "bell")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            // Completed indicator
                            if event.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    // Description (if available)
                    if let description = event.description, !description.isEmpty {
                        Text(description)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(event.eventType.color.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        EventCard(
            event: Event(
                title: "John's Birthday",
                description: "Celebrate John's 29th birthday with friends and family",
                eventType: .birthday,
                contactId: "1",
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                recurrence: RecurrenceRule(frequency: .yearly),
                reminders: [EventReminder(interval: .oneDay)]
            ),
            contactName: "John Doe"
        ) {
            // Handle tap
        }
        
        EventCard(
            event: Event(
                title: "Project Meeting",
                description: "Quarterly planning session",
                eventType: .meeting,
                date: Date(),
                reminders: [EventReminder(interval: .oneHour)]
            ),
            contactName: nil
        ) {
            // Handle tap
        }
        
        EventCard(
            event: Event(
                title: "Wedding Anniversary",
                description: "Our 5th anniversary celebration",
                eventType: .anniversary,
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                recurrence: RecurrenceRule(frequency: .yearly),
                isCompleted: true
            ),
            contactName: nil
        ) {
            // Handle tap
        }
    }
    .padding()
}