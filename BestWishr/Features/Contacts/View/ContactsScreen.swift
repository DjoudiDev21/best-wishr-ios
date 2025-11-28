import SwiftUI

struct ContactsScreen: View {
    @EnvironmentObject var viewModel: ContactsViewModel
    @EnvironmentObject var addContactViewModel: AddContactViewModel
    @EnvironmentObject var appStore: AppStore
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with title and stats
                VStack(spacing: 16) {
                    ScreenHeader(
                        title: "My Contacts",
                        subtitle: "\(viewModel.contactCount) contacts",
                        actionIcon: "plus.circle.fill"
                    ) {
                        viewModel.showAddContact()
                    }
                    
                    // Quick stats
                    ContactQuickStats(
                        contacts: viewModel.allContacts,
                        upcomingEventsCount: viewModel.upcomingEventsCount
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Search and filters
                VStack(spacing: 12) {
                    SearchBar(
                        text: $viewModel.searchText,
                        placeholder: "Search contacts..."
                    )
                    
                    ContactCategoryFilter(selectedCategory: $viewModel.selectedCategory)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Contacts list
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading contacts...")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.contacts.isEmpty {
                    EmptyStateView(
                        icon: viewModel.emptyStateIcon,
                        title: viewModel.emptyStateTitle,
                        message: viewModel.emptyStateMessage,
                        actionTitle: viewModel.showEmptyStateAction ? "Add Your First Contact" : nil
                    ) {
                        viewModel.showAddContact()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.contacts) { contact in
                                ContactCard(
                                    contact: contact,
                                    hasUpcomingEvent: viewModel.hasUpcomingEvent(for: contact)
                                ) {
                                    viewModel.selectContact(contact)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .refreshable {
                        await viewModel.loadContacts()
                    }
                }
                
                Spacer()
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
        .sheet(isPresented: $viewModel.showingAddContact) {
            AddContactScreen()
        }
        .sheet(isPresented: $viewModel.showingContactDetail) {
            if let selectedContact = viewModel.selectedContact {
                ContactDetailScreen(
                    contact: selectedContact,
                    contactsStore: appStore.contactsStore
                )
            }
        }
    }
}
