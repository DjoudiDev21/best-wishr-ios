import SwiftUI

struct AddContactForm: View {
    @Binding var contactData: ContactCreationData
    
    var body: some View {
        VStack(spacing: 20) {
            // First Name
            AddContactFormField(title: "First Name", required: true) {
                TextField("First name", text: $contactData.firstName)
                    .textFieldStyle(AddContactTextFieldStyle())
            }
            
            // Last Name
            AddContactFormField(title: "Last Name", required: true) {
                TextField("Last name", text: $contactData.lastName)
                    .textFieldStyle(AddContactTextFieldStyle())
            }
            
            // Email
            AddContactFormField(title: "Email", required: false) {
                TextField("email@example.com", text: $contactData.email)
                    .textFieldStyle(AddContactTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            
            // Phone Number
            AddContactFormField(title: "Phone Number", required: false) {
                TextField("(555) 123-4567", text: $contactData.phoneNumber)
                    .textFieldStyle(AddContactTextFieldStyle())
                    .keyboardType(.phonePad)
            }
            
            // Category
            AddContactFormField(title: "Category", required: true) {
                Menu {
                    ForEach(ContactCategory.allCases) { category in
                        Button(action: {
                            contactData.category = category
                        }) {
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                                Spacer()
                                if contactData.category == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: contactData.category.icon)
                            .foregroundColor(contactData.category.color)
                        
                        Text(contactData.category.rawValue)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
            
            // Birthday Toggle
            AddContactToggleField(
                title: "Track Birthday",
                subtitle: "Add date of birth for birthday reminders",
                isOn: $contactData.hasBirthday
            )
            
            // Date of Birth (if enabled)
            if contactData.hasBirthday {
                AddContactFormField(title: "Date of Birth", required: true) {
                    DatePicker("", selection: Binding(
                        get: { contactData.dateOfBirth ?? Date() },
                        set: { contactData.dateOfBirth = $0 }
                    ), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .transition(.slide)
            }
        }
    }
}

struct AddContactFormField<Content: View>: View {
    let title: String
    let required: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                if required {
                    Text("*")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            
            content
        }
    }
}

struct AddContactToggleField: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                
                Text(subtitle)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.2, green: 0.6, blue: 0.9)))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct AddContactTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

#Preview {
    AddContactForm(contactData: .constant(ContactCreationData()))
        .padding()
}