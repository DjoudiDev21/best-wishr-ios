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
                            .fill(event.type.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: event.type.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(event.type.color)
                    }
                    
                    // Date info
                    VStack(spacing: 2) {
                        Text(event.shortFormattedDate)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        if event.isToday {
                            Text("Today")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(event.type.color)
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
                                .fill(event.type.color)
                                .frame(width: 8, height: 8)
                            
                            Text(event.type.rawValue)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(event.type.color)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(event.type.color.opacity(0.1))
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
                            .stroke(event.type.color.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
