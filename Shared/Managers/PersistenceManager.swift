//
//  PersistenceManager.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 24/11/2020.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private init() {}
    
    func fetchReminders() -> [Reminder] {
        if let reminders: [Reminder] = FileManager.default.fetchData(from: FileManagerNames.allReminders) {
            return reminders
        }
        return []
    }
    
    func saveReminders(_ reminders: [Reminder]) {
        print("I've been asked to save these guys.... \(reminders)")
        FileManager.default.writeData(reminders, to: FileManagerNames.allReminders)
    }
    
    
}
