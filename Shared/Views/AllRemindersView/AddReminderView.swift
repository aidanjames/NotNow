//
//  AddReminderView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 26/11/2020.
//

import SwiftUI

struct AddReminderView: View {
    @ObservedObject var viewModel: AllRemindersViewModel
    
    
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
            .navigationTitle(Text("Add new reminder"))
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        if selectedDueDateOption == 1 { scheduleReminder = false }
                        viewModel.addNewReminder(title: title, description: description, nextDueDate: selectedDueDateOption == 0 ? reminderDate : Date.futureDate, notificationDates: scheduleReminder ? [reminderDate] : [], tags: tags)
                        presentationMode.wrappedValue.dismiss()
                        
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
}

struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReminderView(viewModel: AllRemindersViewModel())
    }
}
