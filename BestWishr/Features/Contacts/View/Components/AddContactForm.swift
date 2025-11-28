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
            AddContactFormField(title: "Last Name", required: false) {
                TextField("Last name", text: $contactData.lastName)
                    .textFieldStyle(AddContactTextFieldStyle())
            }
            
            // Email
            AddContactFormField(title: "Email", required: false) {
                TextField("email@example.com", text: $contactData.email)
                    .textFieldStyle(AddContactTextFieldStyle())
                #if os(iOS)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                #endif
            }
            
            // Phone Number
            AddContactFormField(title: "Phone Number", required: false) {
                HStack(spacing: 8) {
                    // Country Picker (Compact)
                    Menu {
                        ForEach(Country.allCountries) { country in
                            Button(action: { contactData.phoneCountry = country }) {
                                HStack {
                                    Text(country.displayName)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if contactData.phoneCountry.id == country.id {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text(contactData.phoneCountry.flag)
                                .font(.title3)
                            Text(contactData.phoneCountry.phoneCode)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    // Phone Number Input
                    TextField("(555) 123-4567", text: $contactData.phoneNumber)
                        .textFieldStyle(AddContactTextFieldStyle())
                    #if os(iOS)
                        .keyboardType(.phonePad)
                    #endif
                }
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
            
            // Description
            AddContactFormField(title: "Description", required: false) {
                TextField("Add a note about this contact...", text: $contactData.description, axis: .vertical)
                    .textFieldStyle(AddContactTextAreaStyle())
                    .lineLimit(3...6)
            }
            
            // Interests
            AddContactFormField(title: "Interests", required: false) {
                AddContactInterestsField(interests: $contactData.interests)
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

struct AddContactTextAreaStyle: TextFieldStyle {
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

struct AddContactInterestsField: View {
    @Binding var interests: [String]
    @State private var newInterest: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Add Interest Input
            HStack(spacing: 8) {
                TextField("Add an interest...", text: $newInterest)
                    .textFieldStyle(AddContactTextFieldStyle())
                    .onSubmit {
                        addInterest()
                    }
                
                Button(action: addInterest) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                }
                .disabled(newInterest.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            // Interests Tags
            if !interests.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(Array(interests.enumerated()), id: \.offset) { index, interest in
                        HStack(spacing: 6) {
                            Text(interest)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Button(action: {
                                interests.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }
    
    private func addInterest() {
        let trimmedInterest = newInterest.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedInterest.isEmpty && !interests.contains(trimmedInterest) {
            interests.append(trimmedInterest)
            newInterest = ""
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.bounds
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                      y: bounds.minY + result.frames[index].minY),
                          proposal: ProposedViewSize(result.frames[index].size))
        }
    }
    
    struct FlowResult {
        var bounds = CGSize.zero
        var frames: [CGRect] = []
        
        init(in maxWidth: CGFloat, subviews: Layout.Subviews, spacing: CGFloat) {
            var origin = CGPoint.zero
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if origin.x + size.width > maxWidth {
                    // Move to next row
                    origin.x = 0
                    origin.y += rowHeight + spacing
                    rowHeight = 0
                }
                
                frames.append(CGRect(origin: origin, size: size))
                
                // Update for next iteration
                origin.x += size.width + spacing
                rowHeight = max(rowHeight, size.height)
            }
            
            bounds = CGSize(
                width: maxWidth,
                height: origin.y + rowHeight
            )
        }
    }
}
