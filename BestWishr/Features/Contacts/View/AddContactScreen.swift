import SwiftUI

struct AddContactScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appStore: AppStore
    @State private var contactData = ContactCreationData()
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Form Header
                    AddContactHeader()
                    
                    // Contact Form
                    AddContactForm(contactData: $contactData)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Add Contact")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    Task {
                        await saveContact()
                    }
                }
                .disabled(!contactData.isValid || isSubmitting)
            )
        }
    }
    
    private func saveContact() async {
        isSubmitting = true
        
        let success = await appStore.contactsStore.createContact(contactData)
        
        if success {
            dismiss()
        }
        // Error handling is done by ContactsStore and GlobalErrorHandler
        
        isSubmitting = false
    }
}

struct AddContactHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
            
            VStack(spacing: 4) {
                Text("Add New Contact")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Text("Keep track of important people in your life")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    AddContactScreen()
        .environmentObject(AppStore())
}