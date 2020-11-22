//
//  Reminder.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 22/11/2020.
//

import Foundation

struct Reminder: Codable, Identifiable {
    var id = UUID()
    var created = Date()
    var reminderDates = [Date]()
    var title: String
    var description: String
    var URL: String?
    
    var dueDate: Date {
        if reminderDates.isEmpty { return created }
        return reminderDates.first(where: { $0 > Date() }) ?? reminderDates.last!
    }
}
