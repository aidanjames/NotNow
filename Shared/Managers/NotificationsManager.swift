//
//  NotificationsManager.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 23/11/2020.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    private init() {}
    
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func scheduleNewNotification(id: String, reminderId: String, title: String, subtitle: String, delay: Double?, date: Date?) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default
            content.userInfo = ["REMINDER_ID": reminderId]
            
            if let notificationDate = date { // If we have a date, use that
                let notificationCategory = notificationDate.notificationCategoryToUse().rawValue
                content.categoryIdentifier = notificationCategory

                
                let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate.notificationDateComponents(), repeats: false)
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                self.center.add(request)
                
            } else if let notificationDelay = delay { // Othersise, if we have a delay, use that.
                
                content.categoryIdentifier = "REMINDER_NOTIFICATION"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationDelay, repeats: false)
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                self.center.add(request)
            }

        }
    }
    
    
    func scheduleNewNotification2(id: String, reminderId: String, title: String, subtitle: String, notificationCategory: NotificationCategory, date: DateComponents) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default
            content.userInfo = ["REMINDER_ID": reminderId]
            content.categoryIdentifier = notificationCategory.rawValue

            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            self.center.add(request)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func cancelSpecificNotifications(ids: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    
    
    func cancelAllNotificaitons() {
        center.removeAllPendingNotificationRequests()
    }
    
    // To be deleted - diagnostics only
    func printAllNotifications() {
        print("Should be getting notifications now")
        center.getPendingNotificationRequests() { notifications in
            for notification in notifications {
                print("\(notification.identifier): \(notification.content)")
            }
        }
    }
    
}

enum NotificationCategory: String {
    case weekdayDay // Tomorrow morning, This evening, This weekend
    case weekendDay // Tomorrow morning, This evening, Next weekend
    case weekdayAfternoon // Tomorrow morning, This weekend
    case weekendAfternoon // Tomorrow morning, Next weekend
}
