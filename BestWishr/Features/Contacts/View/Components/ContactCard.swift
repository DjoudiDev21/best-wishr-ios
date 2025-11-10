import SwiftUI

struct ContactCard: View {
    let contact: Contact
    let hasUpcomingEvent: Bool // TODO: This will come from events module later
    let onTap: () -> Void
    
    init(contact: Contact, hasUpcomingEvent: Bool = false, onTap: @escaping () -> Void) {
        self.contact = contact
        self.hasUpcomingEvent = hasUpcomingEvent
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Avatar
                ContactAvatar(
                    firstName: contact.firstName,
                    lastName: contact.lastName,
                    size: 50
                )
                
                // Contact info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("\(contact.firstName) \(contact.lastName)")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                        
                        if hasUpcomingEvent {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.75, green: 0.4, blue: 0.9))
                        }
                        
                        Spacer()
                    }
                    
                    if let email = contact.email {
                        Text(email)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                    }
                    
                    HStack(spacing: 8) {
                        ContactCategoryBadge(category: contact.category)
                        
                        if let dateOfBirth = contact.dateOfBirth {
                            Text(DateFormatter.shortDate.string(from: dateOfBirth))
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.7))
                        }
                        
                        Spacer()
                    }
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.03),
                        Color(red: 0.75, green: 0.4, blue: 0.9).opacity(0.01)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.1),
                                Color(red: 0.75, green: 0.4, blue: 0.9).opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleContact1 = Contact(
        id: "1",
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
        phoneNumber: "+1234567890",
        dateOfBirth: Date(),
        category: .friends,
        avatar: nil,
        createdAt: Date(),
        updatedAt: Date()
    )
    
    let sampleContact2 = Contact(
        id: "2",
        firstName: "Jane",
        lastName: "Smith",
        email: nil,
        phoneNumber: nil,
        dateOfBirth: Date(),
        category: .family,
        avatar: nil,
        createdAt: Date(),
        updatedAt: Date()
    )
    
    return VStack(spacing: 12) {
        ContactCard(
            contact: sampleContact1,
            hasUpcomingEvent: true
        ) {
            print("Contact tapped")
        }
        
        ContactCard(
            contact: sampleContact2,
            hasUpcomingEvent: false
        ) {
            print("Contact tapped")
        }
    }
    .padding()
}