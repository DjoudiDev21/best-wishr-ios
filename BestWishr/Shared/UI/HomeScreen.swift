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
            
            SettingsTabView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.blue)
    }
}

struct HomeTabView: View {
    @EnvironmentObject var appStore: AppStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to BestWishr!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                if let user = appStore.authStore.user {
                    VStack(spacing: 8) {
                        Text("Hello, \(user.firstName ?? "User")!")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
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
                            .fill(Color.blue.gradient)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("\(user.firstName?.prefix(1) ?? "U")\(user.lastName?.prefix(1) ?? "U")")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 4) {
                            Text("\(user.firstName ?? "User") \(user.lastName ?? "")")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
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
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    HomeScreen()
        .environmentObject(AppStore())
}
