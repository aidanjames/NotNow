//
//  NotificationsManager.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 23/11/2020.
//

import CoreLocation
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

    
    func scheduleNewNotification(id: String, reminderId: String, title: String, subtitle: String, notificationCategory: NotificationCategory, date: DateComponents) {
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
    
    
    func scheduleNewNotificationByLocation(id: String, reminderId: String, title: String, subtitle: String, notificationCategory: NotificationCategory, location: CLRegion) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default
            content.userInfo = ["REMINDER_ID": reminderId]
            content.categoryIdentifier = notificationCategory.rawValue

            let trigger = UNLocationNotificationTrigger(region: location, repeats: false)
            
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
    case weekdayMorning // This afternoon, This evening, This weekend
    case weekendMorning // This afternoon, This evening, Next weekend
    case weekdayDay // Tomorrow morning, This evening, This weekend
    case weekendDay // Tomorrow morning, This evening, Next weekend
    case weekdayAfternoon // Tomorrow morning, This weekend
    case weekendAfternoon // Tomorrow morning, Next weekend
    case location // Location based
}
