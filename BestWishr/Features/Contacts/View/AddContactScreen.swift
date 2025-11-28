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
                .padding(.top, 20)
                .overlay(
                    // Floating Buttons
                    VStack {
                        Spacer()
                        HStack {
                            // Cancel Button (always visible)
                            Button(action: {
                                dismiss()
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
                            
                            // Save Button
                            Button(action: {
                                Task {
                                    await saveContact()
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Save")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
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
                                .cornerRadius(25)
                                .shadow(color: (viewModel.canSave ? Color(red: 0.65, green: 0.3, blue: 0.8) : Color.gray).opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .disabled(!viewModel.canSave)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    },
                    alignment: .bottom
                )
            }
            .navigationBarHidden(true)
        }
    }
    
    private func saveContact() async {
        let success = await viewModel.saveContact()
        
        if success {
            dismiss()
        }
    }
}

