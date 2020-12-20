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
    @State private var showingSnoozeActionSheet = false
    @State private var showingRescheduleActionSheet = false
    @State private var tappedReminder: UUID?
    
    var tappedReminderTitle: String {
        if let reminderId = tappedReminder {
            if let index = viewModel.allReminders.firstIndex(where: { $0.id == reminderId }) {
                return viewModel.allReminders[index].title
            }
        }
        return ""
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.allRemindersSorted) { reminder in
                        ReminderListView(viewModel: viewModel, showingSnoozeActionSheet: $showingSnoozeActionSheet, tappedReminder: $tappedReminder, reminder: reminder, height: 120)
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
                            .actionSheet(isPresented: $showingSnoozeActionSheet) {
                                ActionSheet(title: Text("Select an option"), message: nil, buttons: [
                                    .destructive(Text("Delete '\(tappedReminderTitle)'")) { showingDeleteWarning.toggle() },
                                    .default(Text("Snooze by 5 minutes")) {
                                        withAnimation {
                                            snoozeTappedReminder(by: 300)
                                        }
                                    },
                                    .default(Text("Snooze by 30 minutes")) {
                                        withAnimation {
                                            snoozeTappedReminder(by: 1800)
                                        }
                                    },
                                    .default(Text("Snooze by 1 hour")) {
                                        withAnimation {
                                            snoozeTappedReminder(by: 3600)
                                        }
                                    },
                                    .default(Text("Snooze by 1 day")) {
                                        withAnimation {
                                            snoozeTappedReminder(by: 86400)
                                        }
                                    },
                                    .default(Text("Reschedule")) { print("Something else") },
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
            viewModel.saveState()
        }
    }
    
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
