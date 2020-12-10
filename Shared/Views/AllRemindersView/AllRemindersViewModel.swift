//
//  AllRemindersViewModel.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 24/11/2020.
//

import Foundation

class AllRemindersViewModel: ObservableObject {
    @Published var allReminders = [Reminder]()
    @Published var showingAddNewReminder: Bool = false
    
    var allRemindersSorted: [Reminder] {
        return allReminders.sorted { $0.nextDueDate < $1.nextDueDate }
    }
    
    init() {
        allReminders = PersistenceManager.shared.fetchReminders()
    }
    
    func addNewReminder(title: String, description: String, nextDueDate: Date, reminderDates: [Date], tags: Set<String>) {
        guard !reminderDates.isEmpty else {
            let newReminder = Reminder(reminderDates: reminderDates, title: title, description: description, URL: nil, scheduledReminders: [], tags: tags, nextDueDate: nextDueDate)
            self.allReminders.append(newReminder)
            PersistenceManager.shared.saveReminders(allReminders)
            return
        }
        
        NotificationManager.shared.requestPermission()
        
        var reminderIds = [String]()
        for date in reminderDates {
            if date > Date() {
                let delay = date - Date()
                let id = UUID().uuidString
                NotificationManager.shared.scheduleNewNotification(id: id, title: title, subtitle: description, delay: delay)
                reminderIds.append(id)
            }
        }
        
        let newReminder = Reminder(reminderDates: reminderDates, title: title, description: description, URL: nil, scheduledReminders: reminderIds, tags: tags, nextDueDate: nextDueDate)
        self.allReminders.append(newReminder)
        PersistenceManager.shared.saveReminders(allReminders)
    }
    
    func deleteReminder(id: UUID) {
        if let index = allReminders.firstIndex(where: { $0.id == id}) {
            // Cancel all notifications associated with the reminder
            NotificationManager.shared.cancelSpecificNotifications(ids: allReminders[index].scheduledReminders)
            allReminders.remove(at: index)
            PersistenceManager.shared.saveReminders(allReminders)
        }
    }

}
