//
//  AddReminderView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 26/11/2020.
//

import SwiftUI

struct AddReminderView: View {
    @ObservedObject var viewModel: AllRemindersViewModel
    var reminder: Reminder?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var reminderDate: Date = Date()
    @State private var scheduleReminder: Bool = true
    @State private var tags: Set<String> = []
    @State private var newTag = ""
    
    var dueDateOptions = ["Specific date/time", "Someday"]
    @State private var selectedDueDateOption = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var saveButtonDisabled: Bool {
        return title.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .onChange(of: title) { value in
                            populateTagsWhilstTyping()
                        }
                }
                Section(header: Text("Additional info (optional)")) {
                    TextEditor(text: $description).frame(height: 70)
                        .font(.caption)
                        .onChange(of: description) { value in
                            populateTagsWhilstTyping()
                        }
                }
                Section(header: Text("When")) {
                    Picker(selection: $selectedDueDateOption, label: Text("When due")) {
                        ForEach(0..<dueDateOptions.count) {
                            Text(self.dueDateOptions[$0])
                        }
                    }
                    if selectedDueDateOption == 0 {
                        DatePicker("Date/time", selection: $reminderDate)
                        Toggle("Shedule reminder?", isOn: $scheduleReminder)
                    }
                }
                Section(header: Text("Tags (use hashtags to add tags)")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(tags), id: \.self) { tag in
                                TagView(tagName: tag, font: .caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("\(reminder != nil ? "Edit" : "New") reminder"))
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        saveReminder()
                    }) {
                        Text("Save")
                    }
                    .disabled(saveButtonDisabled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                    }
                }
            })
            .onAppear {
                populateExistingReminderDetails()
            }
            .onDisappear {
                viewModel.editReminder = false
                viewModel.tappedReminder = nil
            }
        }
    }
    
    func populateTagsWhilstTyping() {
        var tempTagsSet: Set<String> = []
        let splitTitle = title.components(separatedBy: " ")
        let splitDescription = description.components(separatedBy: " ")
        for word in splitTitle {
            if word.contains("#") {
                tempTagsSet.insert(word)
            }
        }
        for word in splitDescription {
            if word.contains("#") {
                tempTagsSet.insert(word)
            }
        }
        tags = tempTagsSet
    }
    
    func populateExistingReminderDetails() {
        guard reminder != nil else { return }
        title = reminder!.title
        description = reminder!.description
        if reminder!.nextDueDate == Date.futureDate {
            selectedDueDateOption = 1
        } else if reminder!.nextDueDate < Date() {
            reminderDate = Date()
        } else {
            reminderDate = reminder!.nextDueDate
        }
        tags = reminder!.tags
    }
    
    func saveReminder() {
        if reminder != nil {
            // Find the existing reminder and update it
            if selectedDueDateOption == 1 { scheduleReminder = false }
            // Make a new reminder object (which will just be a copy of the updated existing reminder)
            if let reminder = reminder {
                let updatedReminder = Reminder(id: reminder.id, createdDate: reminder.createdDate, title: title, description: description, URL: nil, tags: tags, nextDueDate: reminderDate, completed: false, notifications: [:])
                viewModel.updateReminder(reminder: updatedReminder, notificationDates: scheduleReminder ? [reminderDate] : [])
            }
        } else {
            // Add new reminder
            if selectedDueDateOption == 1 { scheduleReminder = false }
            viewModel.addNewReminder(title: title, description: description, nextDueDate: selectedDueDateOption == 0 ? reminderDate : Date.futureDate, notificationDates: scheduleReminder ? [reminderDate] : [], tags: tags)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReminderView(viewModel: AllRemindersViewModel(), reminder: Reminder(title: "My reminder", description: "This", nextDueDate: Date()))
    }
}
