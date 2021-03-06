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
    
    var tappedReminderTitle: String {
        if let reminderId = viewModel.tappedReminder {
            if let index = viewModel.allReminders.firstIndex(where: { $0.id == reminderId }) {
                return viewModel.allReminders[index].title
            }
        }
        return ""
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.allRemindersSorted) { reminder in
                    ReminderListView(viewModel: viewModel, showingSnoozeActionSheet: $showingSnoozeActionSheet, reminder: reminder, height: 110)
                        .alert(isPresented: $showingDeleteWarning) {
                            Alert(
                                title: Text("Are you sure you want to delete this?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        viewModel.deleteNotificationsForReminder(id: viewModel.tappedReminder!)
                                    }
                                },
                                secondaryButton: .cancel())
                        }
                        .actionSheet(isPresented: $showingSnoozeActionSheet) {
                            ActionSheet(title: Text("Select an option"), message: nil, buttons: [
                                .destructive(Text("Delete '\(tappedReminderTitle)'")) { showingDeleteWarning.toggle() },
                                .default(Text("Snooze by 30 seconds")) {
                                    withAnimation {
                                        snoozeTappedReminder(by: 30)
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
                                .default(Text("Snooze until tomorrow morning")) {
                                    if let index = viewModel.allReminders.firstIndex(where: { $0.id == viewModel.tappedReminder } ) {
                                        withAnimation {
                                            viewModel.allReminders[index].nextDueDate = Date().tomorrowMorning()
                                            viewModel.allReminders[index].scheduleNewNotification(on: Date().tomorrowMorning())
                                            viewModel.saveState()
                                            viewModel.tappedReminder = nil
                                        }
                                    }
                                },
                                .default(Text("Edit/Reschedule")) {
                                    viewModel.editReminder = true
                                    viewModel.showingAddNewReminder = true
                                },
                                .cancel()
                            ])
                        }
                }
            }
            .padding(.horizontal, 10)
        }
        .fullScreenCover(isPresented: $viewModel.showingAddNewReminder) {
            AddOrEditReminderView(viewModel: viewModel, reminder: viewModel.editReminder ? findReminderWithId(id: viewModel.tappedReminder!) : nil)
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
//            ToolbarItem(placement: .cancellationAction) {
//                Button(action: {
//                    NotificationManager.shared.printAllNotifications()
//                }) {
//                    Text("print notifications")
//                }
//            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.refreshData()
        }
        
    }
    
    func snoozeTappedReminder(by seconds: Double) {
        if let index = viewModel.allReminders.firstIndex(where: { $0.id == viewModel.tappedReminder } ) {
            viewModel.allReminders[index].snoozeDueTime(by: seconds)
            viewModel.saveState()
            viewModel.tappedReminder = nil
        }
    }
    
    func findReminderWithId(id: UUID) -> Reminder? {
        if let index = viewModel.allReminders.firstIndex(where: { $0.id == viewModel.tappedReminder } ) {
            return viewModel.allReminders[index]
        }
        return nil
    }
    
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
