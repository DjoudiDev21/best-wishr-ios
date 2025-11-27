import SwiftUI

struct AddContactScreen: View {
    @EnvironmentObject var viewModel: AddContactViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Form Header
                    AddContactHeader()
                    
                    // Contact Form
                    AddContactForm(contactData: $viewModel.contactData)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Add Contact")
            #if os(iOS)
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
                .disabled(!viewModel.canSave)
            )
            #endif
        }
    }
    
    private func saveContact() async {
        let success = await viewModel.saveContact()
        
        if success {
            dismiss()
        }
    }
}

