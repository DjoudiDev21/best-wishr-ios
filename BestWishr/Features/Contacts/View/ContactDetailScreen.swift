import SwiftUI

struct ContactDetailScreen: View {
    @StateObject private var viewModel: ContactDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(contact: Contact, contactsStore: ContactsStore) {
        _viewModel = StateObject(wrappedValue: ContactDetailViewModel(contact: contact, contactsStore: contactsStore))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Contact Header
                    ContactDetailHeader(
                        contact: viewModel.contact,
                        isEditing: viewModel.isEditing
                    )
                    
                    // Contact Information
                    if viewModel.isEditing {
                        ContactEditForm(contactData: $viewModel.editableData)
                    } else {
                        ContactDetailInfo(contact: viewModel.contact)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .overlay(
                    // Floating Buttons
                    VStack {
                        Spacer()
                        HStack {
                            // Close Button (always visible)
                            Button(action: {
                                if viewModel.isEditing {
                                    viewModel.cancelEditing()
                                } else {
                                    dismiss()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        LinearGradient(
                                            colors: [
                                                Color.gray.opacity(0.8),
                                                Color.gray.opacity(0.6)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            Spacer()
                            
                            // Edit/Save Buttons
                            if !viewModel.isEditing {
                                Button(action: {
                                    viewModel.startEditing()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("Edit")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.65, green: 0.3, blue: 0.8),
                                                Color(red: 0.75, green: 0.4, blue: 0.9)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.3), radius: 10, x: 0, y: 5)
                                }
                            } else {
                                Button("Save") {
                                    Task {
                                        await viewModel.saveContact()
                                    }
                                }
                                .disabled(!viewModel.canSave)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            viewModel.canSave ? Color(red: 0.65, green: 0.3, blue: 0.8) : Color.gray,
                                            viewModel.canSave ? Color(red: 0.75, green: 0.4, blue: 0.9) : Color.gray
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .shadow(color: (viewModel.canSave ? Color(red: 0.65, green: 0.3, blue: 0.8) : Color.gray).opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    },
                    alignment: .bottom
                )
            }
            .navigationBarHidden(true)
            .overlay(
                // Loading overlay
                Group {
                    if viewModel.isLoading {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text(viewModel.isEditing ? "Saving contact..." : "Loading...")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        .padding(24)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 10)
                    }
                }
            )
        }
    }
}

struct ContactDetailHeader: View {
    let contact: Contact
    let isEditing: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                contact.category.color,
                                contact.category.color.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text(contact.initials)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            // Name and Category
            VStack(spacing: 8) {
                Text(contact.fullName)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Image(systemName: contact.category.icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(contact.category.color)
                    
                    Text(contact.category.rawValue)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(contact.category.color)
                }
            }
        }
    }
}

struct ContactDetailInfo: View {
    let contact: Contact
    
    var body: some View {
        VStack(spacing: 20) {
            // Basic Information
            ContactInfoSection(title: "Basic Information") {
                VStack(spacing: 12) {
                    // Always show category
                    ContactInfoRow(
                        icon: contact.category.icon,
                        label: "Category",
                        value: contact.category.rawValue
                    )
                    
                    // Email - show value or placeholder
                    ContactInfoRow(
                        icon: "envelope",
                        label: "Email",
                        value: contact.email?.isEmpty == false ? contact.email! : "Not provided",
                        isPlaceholder: contact.email?.isEmpty ?? true
                    )
                    
                    // Phone - show value or placeholder
                    ContactInfoRow(
                        icon: "phone",
                        label: "Phone",
                        value: contact.phoneNumber?.isEmpty == false ? contact.phoneNumber! : "Not provided",
                        isPlaceholder: contact.phoneNumber?.isEmpty ?? true
                    )
                    
                    // Birthday - show value or placeholder
                    if let birthday = contact.dateOfBirth {
                        ContactInfoRow(
                            icon: "calendar",
                            label: "Birthday",
                            value: DateFormatter.longStyle.string(from: birthday)
                        )
                        
                        let age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
                        ContactInfoRow(
                            icon: "person",
                            label: "Age",
                            value: "\(age) years old"
                        )
                    } else {
                        ContactInfoRow(
                            icon: "calendar",
                            label: "Birthday",
                            value: "Not provided",
                            isPlaceholder: true
                        )
                    }
                }
            }
            
            // Additional Information - always show this section
            ContactInfoSection(title: "Additional Information") {
                VStack(spacing: 12) {
                    // Description - show value or placeholder
                    ContactInfoRow(
                        icon: "text.alignleft",
                        label: "Description",
                        value: contact.description?.isEmpty == false ? contact.description! : "Not provided",
                        isPlaceholder: contact.description?.isEmpty ?? true
                    )
                    
                    // Interests - show value or placeholder
                    ContactInfoRow(
                        icon: "heart",
                        label: "Interests",
                        value: {
                            if let interests = contact.interests, !interests.isEmpty {
                                return interests.joined(separator: ", ")
                            } else {
                                return "Not provided"
                            }
                        }(),
                        isPlaceholder: contact.interests?.isEmpty ?? true
                    )
                }
            }
            
            // Timestamps
            ContactInfoSection(title: "Details") {
                VStack(spacing: 12) {
                    ContactInfoRow(
                        icon: "calendar.badge.plus",
                        label: "Added",
                        value: DateFormatter.shortDateTime.string(from: contact.createdAt)
                    )
                    
                    ContactInfoRow(
                        icon: "calendar.badge.clock",
                        label: "Updated",
                        value: DateFormatter.shortDateTime.string(from: contact.updatedAt)
                    )
                }
            }
        }
    }
}

struct ContactEditForm: View {
    @Binding var contactData: ContactCreationData
    
    var body: some View {
        VStack(spacing: 20) {
            ContactInfoSection(title: "Edit Contact") {
                AddContactForm(contactData: $contactData)
            }
        }
    }
}

struct ContactInfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            VStack(spacing: 0) {
                content
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}

struct ContactInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let isPlaceholder: Bool
    
    init(icon: String, label: String, value: String, isPlaceholder: Bool = false) {
        self.icon = icon
        self.label = label
        self.value = value
        self.isPlaceholder = isPlaceholder
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                .frame(width: 20, height: 20)
            
            Text(label)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .frame(minWidth: 80, maxWidth: 100, alignment: .leading)
            
            Text(value)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(isPlaceholder ? .secondary : .primary)
                .italic(isPlaceholder)
            
            Spacer()
        }
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let longStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    static let shortDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
