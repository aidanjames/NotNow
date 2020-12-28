//
//  AppDelegate.swift
//  NotNow
//
//  Created by Aidan Pendlebury on 26/12/2020.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("did finish launching with options being called...")
        // Define the custom actions.
        let snooze5Action = UNNotificationAction(identifier: "SNOOZE_5",
                                                 title: "Snooze for 5 minutes",
                                                 options: UNNotificationActionOptions(rawValue: 0))
        let snooze10Action = UNNotificationAction(identifier: "SNOOZE_10",
                                                  title: "Snooze for 10 minutes",
                                                  options: UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let reminderNotificationCategory =
            UNNotificationCategory(identifier: "REMINDER_NOTIFICATION",
                                   actions: [snooze5Action, snooze10Action],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([reminderNotificationCategory])
        // Refiew the following to complete implementation:
        // https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types
        // https://www.youtube.com/watch?v=BW9dVMNNpkY
        // https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-appdelegate-to-a-swiftui-app
        
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Get the reminder ID from the original notification.
        let userInfo = response.notification.request.content.userInfo
        let reminderId = userInfo["REMINDER_ID"] as! String
        
        // Perform the task associated with the action.
        switch response.actionIdentifier {
        case "SNOOZE_5":
            print("I should be snoozing reminder \(reminderId) for 5 minutes")
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                let nextDueDate = Date().addingTimeInterval(300)
                reminders[index].nextDueDate = nextDueDate
                reminders[index].scheduleNewNotification(on: nextDueDate)
                print(reminders)
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
            
        case "SNOOZE_10":
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                let nextDueDate = Date().addingTimeInterval(600)
                reminders[index].nextDueDate = nextDueDate
                reminders[index].scheduleNewNotification(on: nextDueDate)
                print(reminders)
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
                        
        default:
            break
        }
        completionHandler()
    }
    
    
    
}
