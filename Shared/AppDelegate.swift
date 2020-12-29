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
        
        
        // Define the custom actions.
        let snooze10Action = UNNotificationAction(identifier: "SNOOZE_10", title: "Zzz 10 minutes", options: UNNotificationActionOptions(rawValue: 0))
        let snooze1HourAction = UNNotificationAction(identifier: "SNOOZE_1_HOUR", title: "Zzz 1 hour", options: UNNotificationActionOptions(rawValue: 0))
        let snoozeThisEveningAction = UNNotificationAction(identifier: "SNOOZE_THIS_EVENING", title: "Zzz This evening (7pm)", options: UNNotificationActionOptions(rawValue: 0))
        let snoozeTomorrowMorningAction = UNNotificationAction(identifier: "SNOOZE_TOMORROW_MORNING", title: "Zzz Tomorrow morning (10am)", options: UNNotificationActionOptions(rawValue: 0))
        let snoozeThisWeekendAction = UNNotificationAction(identifier: "SNOOZE_THIS_WEEKEND", title: "Zzz Sat morning (10am)", options: UNNotificationActionOptions(rawValue: 0))
        let markCompleteAction = UNNotificationAction(identifier: "MARK_COMPLETE", title: "Mark complete", options: UNNotificationActionOptions(rawValue: 0))
        let editRescheduleAction = UNNotificationAction(identifier: "EDIT_RESCHEDULE", title: "Edit/Reschedule", options: .foreground)

        // Define the notification type
        let reminderNotificationCategory =
            UNNotificationCategory(identifier: "REMINDER_NOTIFICATION",
                                   actions: [snooze10Action, snooze1HourAction, snoozeThisEveningAction, snoozeTomorrowMorningAction, snoozeThisWeekendAction, markCompleteAction, editRescheduleAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)

        
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([reminderNotificationCategory])
        // Review the following to complete implementation:
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
           
        case "SNOOZE_10":
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                let nextDueDate = Date().addingTimeInterval(600)
                reminders[index].nextDueDate = nextDueDate
                reminders[index].scheduleNewNotification(on: nextDueDate)
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
        case "SNOOZE_1_HOUR":
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                let nextDueDate = Date().addingTimeInterval(3600)
                reminders[index].nextDueDate = nextDueDate
                reminders[index].scheduleNewNotification(on: nextDueDate)
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
        case "SNOOZE_THIS_EVENING":
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                // TODO - Calculate time until closest 7pm
                let nextDueDate = Date().addingTimeInterval(300)
                reminders[index].nextDueDate = nextDueDate
                reminders[index].scheduleNewNotification(on: nextDueDate)
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
        case "SNOOZE_TOMORROW_MORNING":
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                // TODO - Calculate time until closest 10am
                let nextDueDate = Date().addingTimeInterval(300)
                reminders[index].nextDueDate = nextDueDate
                reminders[index].scheduleNewNotification(on: nextDueDate)
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
        case "SNOOZE_THIS_WEEKEND":
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                // TODO - Calculate time until closest Sat 10am
                let nextDueDate = Date().addingTimeInterval(15)
                reminders[index].nextDueDate = nextDueDate
                reminders[index].scheduleNewNotification(on: nextDueDate)
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
        case "MARK_COMPLETE":
            var reminders = PersistenceManager.shared.fetchReminders()
            if let index = reminders.firstIndex(where: { $0.id.uuidString == reminderId }) {
                reminders[index].completed.toggle()
                reminders[index].nextDueDate = Date.completedDate
                PersistenceManager.shared.saveReminders(reminders)
            }
            break
        case "EDIT_RESCHEDULE":
            // TODO - Open the app on the correct reminder edit page (do I need to initiate the view model in here?
            print("This is where I need to make it open on the correct reminder edit page")
            break
            
        default:
            break
        }
        completionHandler()
    }
    
    
    
}
