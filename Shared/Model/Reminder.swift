//
//  Reminder.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 22/11/2020.
//

import Foundation

struct Reminder: Codable, Identifiable {
    var id = UUID()
    var createdDate = Date()
//    var reminderDates = [Date]()
    var title: String
    var description: String
    var URL: String?
//    var scheduledReminders = [String]()
    var tags = Set<String>()
    var nextDueDate: Date
    var completed = false
    
    var notifications = [String: Date]()

    
    mutating func cancelAllScheduledReminders() {
        NotificationManager.shared.cancelSpecificNotifications(ids: Array(notifications.keys))
        self.notifications = [:]
    }
    
    mutating func cancelSpecificScheduledReminder(id: String) {
        if let _ = notifications[id] {
            NotificationManager.shared.cancelSpecificNotifications(ids: [id])
            notifications.removeValue(forKey: id)
        }
    }
    
    mutating func scheduleNewReminder(on reminderDate: Date) {
        let reminderId = UUID().uuidString
        let delay = reminderDate.timeIntervalSince(Date())
        NotificationManager.shared.scheduleNewNotification(id: reminderId, title: title, subtitle: description, delay: delay)
        self.notifications[reminderId] = reminderDate
    }
    
    mutating func snoozeDueTime(by seconds: Double) {
        // Calculate the new reminder date/time
        let newTime = Date().addingTimeInterval(seconds)
        // Change the due date
        self.nextDueDate = newTime
        // Delete all notifications for the reminder
        self.cancelAllScheduledReminders()
        // Shedule a new reminder
        self.scheduleNewReminder(on: newTime)
    }
    
}
