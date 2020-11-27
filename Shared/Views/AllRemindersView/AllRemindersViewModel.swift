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
    
    init() {
        allReminders = PersistenceManager.shared.fetchReminders()
    }
    
    func addNewReminder(title: String, description: String, reminderDates: [Date], tags: Set<String>) {
        guard !reminderDates.isEmpty else {
            let newReminder = Reminder(reminderDates: reminderDates, title: title, description: description, URL: nil, scheduledReminders: [], tags: tags)
            self.allReminders.append(newReminder)
            PersistenceManager.shared.saveReminders(allReminders)
            return
        }
        
        NotificationManager.shared.requestPermission()
        
        var reminderIds = [String]()
        for _ in reminderDates {
            // Use the date to work out the delay from today
            let id = UUID().uuidString
            NotificationManager.shared.scheduleNewNotification(id: id, title: title, subtitle: description, delay: 15)
            reminderIds.append(id)
        }
        
        let newReminder = Reminder(reminderDates: reminderDates, title: title, description: description, URL: nil, scheduledReminders: reminderIds)
        self.allReminders.append(newReminder)
        PersistenceManager.shared.saveReminders(allReminders)
    }
}
