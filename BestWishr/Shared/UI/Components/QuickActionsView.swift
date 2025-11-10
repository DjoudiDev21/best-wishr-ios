import SwiftUI

struct QuickActionsView: View {
    @EnvironmentObject var appStore: AppStore
    @State private var showingAddContact = false
    @State private var showingAddEvent = false
    @State private var showingSavedGifts = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Actions")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                QuickActionCard(
                    icon: "person.badge.plus",
                    title: "Add Contact",
                    subtitle: "New person",
                    color: Color(red: 0.2, green: 0.6, blue: 0.9)
                ) {
                    showingAddContact = true
                }
                
                QuickActionCard(
                    icon: "calendar.badge.plus",
                    title: "Add Event",
                    subtitle: "New celebration",
                    color: Color(red: 0.65, green: 0.3, blue: 0.8)
                ) {
                    showingAddEvent = true
                }
            }
            
            HStack(spacing: 12) {
                QuickActionCard(
                    icon: "gift",
                    title: "Gift Ideas",
                    subtitle: "Browse suggestions",
                    color: Color(red: 1.0, green: 0.6, blue: 0.0)
                ) {
                    showingSavedGifts = true
                }
                
                QuickActionCard(
                    icon: "bell.badge",
                    title: "Reminders",
                    subtitle: "Manage alerts",
                    color: Color(red: 0.4, green: 0.8, blue: 0.4)
                ) {
                    // TODO: Implement reminders management
                }
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showingAddContact) {
            // Add contact sheet (placeholder)
            NavigationView {
                VStack {
                    Text("Add Contact")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Contact creation form will be implemented here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle("Add Contact")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingAddContact = false
                    },
                    trailing: Button("Save") {
                        showingAddContact = false
                    }
                )
            }
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventScreen()
        }
        .sheet(isPresented: $showingSavedGifts) {
            SavedGiftsScreen()
        }
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    QuickActionsView()
        .environmentObject(AppStore())
}