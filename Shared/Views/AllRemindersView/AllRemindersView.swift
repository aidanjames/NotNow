//
//  AllRemindersView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 24/11/2020.
//

import SwiftUI

struct AllRemindersView: View {
    @StateObject var viewModel = AllRemindersViewModel()
    @State private var showingDeleteWarning = false
    @State private var showingActionSheet = false
    @State private var tappedReminder: UUID?
        
    var tappedReminderTitle: String {
        if let reminderId = tappedReminder {
            if let index = viewModel.allReminders.firstIndex(where: { $0.id == reminderId }) {
                return viewModel.allReminders[index].title
            }
        }
        return ""
    }
    
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.allRemindersSorted) { reminder in
                        ReminderListView(viewModel: viewModel, showingActionSheet: $showingActionSheet, tappedReminder: $tappedReminder, reminder: reminder, height: 120)
                            .onTapGesture {
                                tappedReminder = reminder.id
                                showingDeleteWarning = true
                            }
                            .alert(isPresented: $showingDeleteWarning) {
                                Alert(
                                    title: Text("Are you sure you want to delete this?"),
                                    message: Text("There is no undo"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        withAnimation {
                                            viewModel.deleteReminder(id: tappedReminder!)
                                        }
                                    },
                                    secondaryButton: .cancel())
                            }
                            .actionSheet(isPresented: $showingActionSheet) {
                                ActionSheet(title: Text("Select an option"), message: nil, buttons: [
                                    .default(Text("Delete '\(tappedReminderTitle)'")) {
                                        showingDeleteWarning.toggle()
                                    },
                                        .default(Text("Snooze by 5 minutes")) { snoozeTappedReminder(by: 300) },
                                        .default(Text("Snooze by 30 minutes")) { snoozeTappedReminder(by: 1800) },
                                        .default(Text("Snooze by 1 hour")) { snoozeTappedReminder(by: 3600) },
                                        .default(Text("Snooze by 1 day")) { snoozeTappedReminder(by: 86400) },
                                        .default(Text("Snooze by custom time")) { print("Something else") },
                                        .cancel()
                                    ])
                            }
                    }
                }
                .padding(.horizontal, 10)
            }
            .fullScreenCover(isPresented: $viewModel.showingAddNewReminder) {
                AddReminderView(viewModel: viewModel)
            }
            .navigationTitle("NotNow").foregroundColor(Color(Colours.midnightBlue))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.showingAddNewReminder = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            }
            
        }
        .accentColor(Color(Colours.hotCoral))
    }
    
    func snoozeTappedReminder(by seconds: Double) {
        if let index = viewModel.allReminders.firstIndex(where: { $0.id == tappedReminder } ) {
            viewModel.allReminders[index].snoozeDueTime(by: seconds)
        }
    }
    
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
