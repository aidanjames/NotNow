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
            if success {
                // Good to go
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func scheduleNewNotification(id: UUID, title: String, subtitle: String, delay: Int) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default
            
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
    
    
}
