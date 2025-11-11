import SwiftUI

struct EventsScreen: View {
    @EnvironmentObject var appStore: AppStore
    @State private var showingAddEvent = false
    
    private var emptyStateTitle: String {
        if !appStore.eventsStore.searchText.isEmpty {
            return "No Events Found"
        } else if appStore.eventsStore.selectedFilter != .all {
            return "No \(appStore.eventsStore.selectedFilter.rawValue) Events"
        } else {
            return "No Events Yet"
        }
    }
    
    private var emptyStateMessage: String {
        if !appStore.eventsStore.searchText.isEmpty {
            return "Try adjusting your search terms or clear filters to see more events."
        } else if appStore.eventsStore.selectedFilter != .all {
            return "You don't have any events in this category yet."
        } else {
            return "Start planning your celebrations and important events."
        }
    }
    
    // Helper to get contact name for an event
    private func contactName(for event: Event) -> String? {
        guard let contactId = event.contactId else { return nil }
        let contact = appStore.contactsStore.contacts.first { $0.id == contactId }
        return contact?.fullName
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with title and stats
                VStack(spacing: 16) {
                    ScreenHeader(
                        title: "My Events",
                        subtitle: "\(appStore.eventsStore.filteredEvents.count) events",
                        actionIcon: "plus.circle.fill"
                    ) {
                        showingAddEvent = true
                    }
                    
                    // Quick stats
                    EventQuickStats(stats: appStore.eventsStore.eventStats)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Search and filters
                VStack(spacing: 12) {
                    SearchBar(
                        text: $appStore.eventsStore.searchText,
                        placeholder: "Search events..."
                    )
                    
                    EventFilterChips(selectedFilter: $appStore.eventsStore.selectedFilter)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Events list
                if appStore.eventsStore.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading events...")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if appStore.eventsStore.filteredEvents.isEmpty {
                    EmptyStateView(
                        icon: appStore.eventsStore.searchText.isEmpty && appStore.eventsStore.selectedFilter == .all ? "calendar.badge.plus" : "magnifyingglass",
                        title: emptyStateTitle,
                        message: emptyStateMessage,
                        actionTitle: (appStore.eventsStore.searchText.isEmpty && appStore.eventsStore.selectedFilter == .all) ? "Add Your First Event" : nil
                    ) {
                        showingAddEvent = true
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(appStore.eventsStore.filteredEvents) { event in
                                EventCard(
                                    event: event,
                                    contactName: contactName(for: event)
                                ) {
                                    // Handle event tap - TODO: Navigate to event detail
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .refreshable {
                        await appStore.eventsStore.loadEvents()
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventScreen()
        }
    }
}

#Preview {
    EventsScreen()
        .environmentObject(AppStore())
}
