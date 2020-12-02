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
    
    func addNewReminder(title: String, description: String, reminderDates: [Date], tags: [String]) {
        guard !reminderDates.isEmpty else {
            let newReminder = Reminder(reminderDates: reminderDates, title: title, description: description, URL: nil, scheduledReminders: [], tags: tags)
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
        
        let newReminder = Reminder(reminderDates: reminderDates, title: title, description: description, URL: nil, scheduledReminders: reminderIds)
        self.allReminders.append(newReminder)
        PersistenceManager.shared.saveReminders(allReminders)
    }
}
