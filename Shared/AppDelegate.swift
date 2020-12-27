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
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("The app delegate function is being called because we received a notification.")
        print("Response.... \(response)")
        if response.actionIdentifier == "snooze5" {
            print("This is the response: \(response)")
        }
        
    }
}
