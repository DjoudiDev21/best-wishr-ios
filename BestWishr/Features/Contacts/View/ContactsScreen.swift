import SwiftUI

struct ContactsScreen: View {
    @EnvironmentObject var appStore: AppStore
    @State private var showingAddContact = false
    
    private var emptyStateTitle: String {
        if !appStore.contactsStore.searchText.isEmpty {
            return "No Results Found"
        } else if appStore.contactsStore.selectedCategory != nil {
            return "No Contacts in Category"
        } else {
            return "No Contacts Yet"
        }
    }
    
    private var emptyStateMessage: String {
        if !appStore.contactsStore.searchText.isEmpty {
            return "Try adjusting your search terms or clear filters to see more contacts."
        } else if appStore.contactsStore.selectedCategory != nil {
            return "You don't have any contacts in this category yet."
        } else {
            return "Start building your contact list to keep track of important dates and celebrations."
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with title and stats
                VStack(spacing: 16) {
                    ScreenHeader(
                        title: "My Contacts",
                        subtitle: "\(appStore.contactsStore.filteredContacts.count) contacts",
                        actionIcon: "plus.circle.fill"
                    ) {
                        showingAddContact = true
                    }
                    
                    // Quick stats
                    ContactQuickStats(
                        contacts: appStore.contactsStore.contacts,
                        upcomingEventsCount: appStore.contactsStore.contactStats.upcomingEventsCount
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Search and filters
                VStack(spacing: 12) {
                    SearchBar(
                        text: $appStore.contactsStore.searchText,
                        placeholder: "Search contacts..."
                    )
                    
                    ContactCategoryFilter(selectedCategory: $appStore.contactsStore.selectedCategory)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Contacts list
                if appStore.contactsStore.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading contacts...")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if appStore.contactsStore.filteredContacts.isEmpty {
                    EmptyStateView(
                        icon: appStore.contactsStore.searchText.isEmpty && appStore.contactsStore.selectedCategory == nil ? "person.3" : "magnifyingglass",
                        title: emptyStateTitle,
                        message: emptyStateMessage,
                        actionTitle: (appStore.contactsStore.searchText.isEmpty && appStore.contactsStore.selectedCategory == nil) ? "Add Your First Contact" : nil
                    ) {
                        showingAddContact = true
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(appStore.contactsStore.filteredContacts) { contact in
                                ContactCard(
                                    contact: contact,
                                    hasUpcomingEvent: false // TODO: Calculate from events module
                                ) {
                                    // Handle contact tap
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .refreshable {
                        await appStore.contactsStore.loadContacts()
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddContact) {
            AddContactScreen()
        }
    }
}

#Preview {
    ContactsScreen()
        .environmentObject(AppStore())
}
