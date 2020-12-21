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
    @Published var tappedReminder: UUID?
    @Published var editReminder = false
    
    var allRemindersSorted: [Reminder] {
        return allReminders.sorted { $0.nextDueDate < $1.nextDueDate }
    }
    
    init() {
        allReminders = PersistenceManager.shared.fetchReminders()
    }
    
    func addNewReminder(title: String, description: String, nextDueDate: Date, notificationDates: [Date], tags: Set<String>) {
        guard !notificationDates.isEmpty else {
            let newReminder = Reminder(title: title, description: description, URL: nil, tags: tags, nextDueDate: nextDueDate)
            self.allReminders.append(newReminder)
            PersistenceManager.shared.saveReminders(allReminders)
            return
        }
        
        NotificationManager.shared.requestPermission()
        
        var reminderIds = [String]()
        var notifications = [String: Date]()
        for date in notificationDates {
            if date > Date() {
                let delay = date - Date()
                let id = UUID().uuidString
                NotificationManager.shared.scheduleNewNotification(id: id, title: title, subtitle: description, delay: delay)
                reminderIds.append(id)
                notifications[id] = Date().addingTimeInterval(delay)
            }
        }
        
        let newReminder = Reminder(title: title, description: description, URL: nil, tags: tags, nextDueDate: nextDueDate, notifications: notifications)
        
        self.allReminders.append(newReminder)
        saveState()
    }
    
    
    func updateReminder(reminder: Reminder) {
        // Find the index in the existing array
        if let index = allReminders.firstIndex(where: { $0.id == reminder.id }) {
            // Replace the reminder with the updated one
            allReminders[index] = reminder
        }
        // Save
        saveState()
    }
    
    
    func deleteReminder(id: UUID) {
        if let index = allReminders.firstIndex(where: { $0.id == id}) {
            // Cancel all notifications associated with the reminder
            NotificationManager.shared.cancelSpecificNotifications(ids: Array(allReminders[index].notifications.keys))
            allReminders.remove(at: index)
            saveState()
        }
    }
    
    func saveState() {
        PersistenceManager.shared.saveReminders(allReminders)
    }

}
