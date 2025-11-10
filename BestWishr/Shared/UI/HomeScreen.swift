import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var appStore: AppStore
    
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ContactsScreen()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Contacts")
                }
            
            EventsScreen()
                .tabItem {
                    Image(systemName: "calendar.badge.plus")
                    Text("Events")
                }
            
            SettingsTabView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(Color(red: 0.65, green: 0.3, blue: 0.8))
    }
}

struct HomeTabView: View {
    @EnvironmentObject var appStore: AppStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    VStack(spacing: 16) {
                        Text("Welcome to BestWishr!")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.65, green: 0.3, blue: 0.8),
                                        Color(red: 0.75, green: 0.4, blue: 0.9)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .multilineTextAlignment(.center)
                        
                        if let user = appStore.authStore.user {
                            Text("Hello, \(user.firstName ?? "User")! 👋")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                        }
                    }
                    
                    // Dashboard Stats
                    DashboardStatsView()
                    
                    // Today's Notifications
                    TodaysNotificationsView()
                    
                    // Quick Actions
                    QuickActionsView()
                    
                    // Upcoming Events Preview (next 30 days)
                    UpcomingEventsPreview()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await loadDashboardData()
            }
        }
    }
    
    private func loadDashboardData() async {
        await appStore.contactsStore.loadContacts()
        await appStore.eventsStore.loadEvents()
    }
}

struct SettingsTabView: View {
    @EnvironmentObject var appStore: AppStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = appStore.authStore.user {
                    VStack(spacing: 12) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.65, green: 0.3, blue: 0.8),
                                        Color(red: 0.75, green: 0.4, blue: 0.9)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("\(user.firstName?.prefix(1) ?? "U")\(user.lastName?.prefix(1) ?? "U")")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 4) {
                            Text("\(user.firstName ?? "User") \(user.lastName ?? "")")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                            
                            Text(user.email)
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 16) {
                    SettingsRow(
                        icon: "person.fill",
                        title: "Profile",
                        subtitle: "Manage your account"
                    )
                    
                    SettingsRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Manage notification settings"
                    )
                    
                    SettingsRow(
                        icon: "lock.fill",
                        title: "Privacy",
                        subtitle: "Privacy and security settings"
                    )
                    
                    SettingsRow(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        subtitle: "Get help and contact support"
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await logout()
                    }
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Settings")
        }
    }
    
    private func logout() async {
        appStore.authStore.logout()
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.05),
                    Color(red: 0.75, green: 0.4, blue: 0.9).opacity(0.02)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}

#Preview {
    HomeScreen()
        .environmentObject(AppStore())
}
