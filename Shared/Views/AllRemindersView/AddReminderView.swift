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
    @State private var scheduleReminder: Bool = false
    @State private var tags = Set<String>()
    @State private var newTag = ""
    
    @Environment(\.presentationMode) var presentationMode

    var saveButtonDisabled: Bool {
        return title.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BaseView()
                Form {
                    Section {
                        TextField("Title", text: $title)
                    }
                    Section(header: Text("Reminder details")) {
                        TextEditor(text: $description).frame(height: 100)
                    }
                    Section(header: Text("Shedule a reminder")) {
                        Toggle("Shedule reminder?", isOn: $scheduleReminder)
                        if scheduleReminder {
                            DatePicker("Date/Time", selection: $reminderDate)
                        }
                    }
                    Section(header: Text("Tags")) {
                        Button("Add new tag") {
                            
                        }
                        Text("Hi there")
                            .padding(7)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(16)
                    }
                }
                .opacity(0.9)
                .navigationTitle(Text("Add new reminder"))
                .toolbar(content: {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                                viewModel.addNewReminder(title: title, description: description, reminderDates: scheduleReminder ? [reminderDate] : [], tags: tags)
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
    }
}

struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReminderView(viewModel: AllRemindersViewModel())
    }
}
