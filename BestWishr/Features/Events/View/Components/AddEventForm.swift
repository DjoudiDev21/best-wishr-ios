import SwiftUI

struct AddEventForm: View {
    @Binding var eventData: EventCreationData
    @EnvironmentObject var appStore: AppStore
    
    var body: some View {
        VStack(spacing: 20) {
            // Event Title
            AddEventFormField(title: "Event Title", required: true) {
                TextField("e.g., John's Birthday", text: $eventData.title)
                    .textFieldStyle(AddEventTextFieldStyle())
            }
            
            // Event Type
            AddEventFormField(title: "Event Type", required: true) {
                Menu {
                    ForEach(EventType.allCases) { type in
                        Button(action: {
                            eventData.type = type
                        }) {
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                                Spacer()
                                if eventData.type == type {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: eventData.type.icon)
                            .foregroundColor(eventData.type.color)
                        
                        Text(eventData.type.rawValue)
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
            
            // Date
            AddEventFormField(title: "Date", required: true) {
                DatePicker("", selection: $eventData.date, displayedComponents: .date)
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
            
            // Contact (Optional)
            AddEventFormField(title: "Contact", required: false) {
                Menu {
                    Button("No Contact") {
                        eventData.contactId = nil
                    }
                    
                    ForEach(appStore.contactsStore.contacts) { contact in
                        Button(action: {
                            eventData.contactId = contact.id
                        }) {
                            HStack {
                                Text(contact.fullName)
                                Spacer()
                                if eventData.contactId == contact.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(Color(red: 0.65, green: 0.3, blue: 0.8))
                        
                        if let contactId = eventData.contactId,
                           let contact = appStore.contactsStore.contacts.first(where: { $0.id == contactId }) {
                            Text(contact.fullName)
                                .foregroundColor(.primary)
                        } else {
                            Text("Select contact (optional)")
                                .foregroundColor(.secondary)
                        }
                        
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
            
            // Description
            AddEventFormField(title: "Description", required: false) {
                TextField("Add details about the event...", text: $eventData.description, axis: .vertical)
                    .textFieldStyle(AddEventTextFieldStyle())
                    .lineLimit(3, reservesSpace: true)
            }
            
            // Recurrence Toggle
            AddEventToggleField(
                title: "Recurring Event",
                subtitle: "Repeat annually",
                isOn: $eventData.isRecurring
            )
            
            // Reminders Toggle
            AddEventToggleField(
                title: "Enable Reminders",
                subtitle: "Get notified before the event",
                isOn: $eventData.hasReminders
            )
            
            // Reminder Selection (when enabled)
            if eventData.hasReminders {
                AddEventReminderSelection(eventData: $eventData)
            }
        }
    }
}

struct AddEventFormField<Content: View>: View {
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

struct AddEventToggleField: View {
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
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.65, green: 0.3, blue: 0.8)))
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

struct AddEventTextFieldStyle: TextFieldStyle {
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

struct AddEventReminderSelection: View {
    @Binding var eventData: EventCreationData
    
    var body: some View {
        AddEventFormField(title: "Reminder Settings", required: false) {
            VStack(spacing: 8) {
                // Display all reminder intervals with dynamic enable/disable
                VStack(spacing: 8) {
                    ForEach(ReminderInterval.allCases) { interval in
                        let isAvailable = eventData.isReminderIntervalAvailable(interval)
                        let isSelected = eventData.selectedReminderIntervals.contains(interval)
                        
                        HStack {
                            Button(action: {
                                if isAvailable {
                                    if isSelected {
                                        eventData.selectedReminderIntervals.remove(interval)
                                    } else {
                                        eventData.selectedReminderIntervals.insert(interval)
                                    }
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 18))
                                        .foregroundColor(isAvailable ? (isSelected ? Color(red: 0.65, green: 0.3, blue: 0.8) : .secondary) : .gray.opacity(0.3))
                                    
                                    Text("Remind me \(interval.rawValue.lowercased()) before")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(isAvailable ? .primary : .gray.opacity(0.5))
                                    
                                    Spacer()
                                    
                                    if !isAvailable {
                                        Text("Too soon")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray.opacity(0.7))
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                            }
                            .disabled(!isAvailable)
                            .buttonStyle(PlainButtonStyle())
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isSelected && isAvailable ? Color(red: 0.65, green: 0.3, blue: 0.8).opacity(0.1) : Color.clear)
                        )
                    }
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
            .onAppear {
                // Auto-select suggested reminders when this view appears
                if eventData.selectedReminderIntervals.isEmpty {
                    eventData.selectedReminderIntervals = eventData.suggestedReminderIntervals()
                }
            }
        }
    }
}

#Preview {
    AddEventForm(eventData: .constant(EventCreationData()))
        .environmentObject(AppStore())
        .padding()
}
