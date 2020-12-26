//
//  NotNowApp.swift
//  Shared
//
//  Created by Aidan Pendlebury on 22/11/2020.
//

import SwiftUI

@main
struct NotNowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AllRemindersView()
            }
            .accentColor(Color(Colours.hotCoral))
        }
    }
}
