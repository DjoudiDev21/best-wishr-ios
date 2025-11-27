import SwiftUI

struct ContactQuickStats: View {
    let contacts: [Contact]
    let upcomingEventsCount: Int // TODO: This will come from events module later
    
    init(contacts: [Contact], upcomingEventsCount: Int = 0) {
        self.contacts = contacts
        self.upcomingEventsCount = upcomingEventsCount
    }
    
    private var thisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        return contacts.filter { contact in
            guard let birthDate = contact.dateOfBirth else { return false }
            let birthComponents = calendar.dateComponents([.month, .day], from: birthDate)
            let nowComponents = calendar.dateComponents([.month], from: now)
            return birthComponents.month == nowComponents.month
        }.count
    }
    
    var body: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Total",
                value: "\(contacts.count)",
                icon: "person.3.fill",
                color: Color(red: 0.65, green: 0.3, blue: 0.8)
            )
            
            StatCard(
                title: "Upcoming Events",
                value: "\(upcomingEventsCount)",
                icon: "calendar.badge.exclamationmark",
                color: Color(red: 0.75, green: 0.4, blue: 0.9)
            )
            
            StatCard(
                title: "This Month",
                value: "\(thisMonthCount)",
                icon: "gift.fill",
                color: Color(red: 0.85, green: 0.5, blue: 0.7)
            )
        }
    }
}
