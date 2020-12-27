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
            // Define the custom actions.
            let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
                  title: "Accept",
                  options: UNNotificationActionOptions(rawValue: 0))
            let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
                  title: "Decline",
                  options: UNNotificationActionOptions(rawValue: 0))
            // Define the notification type
            let meetingInviteCategory =
                  UNNotificationCategory(identifier: "MEETING_INVITATION",
                  actions: [acceptAction, declineAction],
                  intentIdentifiers: [],
                  hiddenPreviewsBodyPlaceholder: "",
                  options: .customDismissAction)
            // Register the notification type.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.setNotificationCategories([meetingInviteCategory])
            // Refiew the following to complete implementation:
            // https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types
            // https://www.youtube.com/watch?v=BW9dVMNNpkY
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-appdelegate-to-a-swiftui-app
        }
    }
    
    
    func scheduleNewNotification(id: String, title: String, subtitle: String, delay: Double) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default
            
            let snooze5 = UNNotificationAction(identifier: "snooze5", title: "Snooze for 5 mins", options: .foreground)
            let snooze10 = UNNotificationAction(identifier: "snooze10", title: "Snooze for 10 mins", options: .foreground)
            let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
            let categories = UNNotificationCategory(identifier: "action", actions: [snooze5, snooze10, cancel], intentIdentifiers: [])
            UNUserNotificationCenter.current().setNotificationCategories([categories])
            content.categoryIdentifier = "action"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
            
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
        center.getPendingNotificationRequests() { notifications in
            for notification in notifications {
                print("\(notification.identifier): \(notification.content)")
            }
        }
    }
    
    
}
