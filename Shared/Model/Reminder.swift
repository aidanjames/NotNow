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
    var reminderDates = [Date]()
    var title: String
    var description: String
    var URL: String?
    var scheduledReminders = [String]()
    var tags = Set<String>()
//    var tags: Set<String> {
//        var tagsToReturn = Set<String>()
//        for word in title.components(separatedBy: " ") {
//            if word.contains("#") {
//                tagsToReturn.insert(word)
//            }
//        }
//        for word in description.components(separatedBy: " ") {
//            if word.contains("#") {
//                tagsToReturn.insert(word)
//            }
//        }
//        return tagsToReturn
//    }
    
    var dueDate: Date {
        if reminderDates.isEmpty { return createdDate }
        return reminderDates.first(where: { $0 > Date() }) ?? reminderDates.last!
    }
    
    mutating func cancelAllScheduledReminders() {
        NotificationManager.shared.cancelSpecificNotifications(ids: scheduledReminders)
        self.scheduledReminders = []
    }
    
    mutating func cancelSpecificScheduledReminder(id: String) {
        if let index = scheduledReminders.firstIndex(of: id) {
            NotificationManager.shared.cancelSpecificNotifications(ids: [scheduledReminders[index]])
            scheduledReminders.remove(at: index)
        }
    }
    
    mutating func scheduleNewReminder(on reminderDate: Date) {
        let reminderId = UUID().uuidString
        let delay = reminderDate.timeIntervalSince(Date())
        NotificationManager.shared.scheduleNewNotification(id: reminderId, title: title, subtitle: description, delay: delay)
        scheduledReminders.append(reminderId)
    }
    
    
}
