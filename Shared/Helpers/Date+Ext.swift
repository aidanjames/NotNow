//
//  Date+Ext.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 29/11/2020.
//

import Foundation

extension Date {
    
    static var futureDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2200/12/31 00:00")!
    }
    
    static var completedDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2300/12/31 00:00")!
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func friendlyDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func next(_ weekday: Weekday, direction: Calendar.SearchDirection = .forward, considerToday: Bool = false) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)

        if considerToday &&
            calendar.component(.weekday, from: self) == weekday.rawValue
        {
            return self
        }

        return calendar.nextDate(after: self,
                                 matching: components,
                                 matchingPolicy: .nextTime,
                                 direction: direction)!
    }
    
    func secondsUntilTomorrowMorning() -> Double {
        // Create a Date object for tomorrow @ 10am
        let thisTimeTomorrow = self.addingTimeInterval(86400)
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.day = calendar.component(.day, from: thisTimeTomorrow)
        components.month = calendar.component(.month, from: thisTimeTomorrow)
        components.year = calendar.component(.year, from: thisTimeTomorrow)
        components.hour = 10
        let tomorrow = calendar.date(from: components)!
                
        // Calculate the time interval and return it
        return tomorrow - self
    }
    
    func secondsUntilThisEvening() -> Double {
        var notificationDate = self
        // If it is already past 19:00 for the current day move the notification date to tomorrow
        let calendar = Calendar(identifier: .gregorian)
        if calendar.component(.hour, from: self) >= 19 {
            notificationDate = self.addingTimeInterval(86400)
        }
        // Make a date object with 19:00 as the time
        var components = DateComponents()
        components.day = calendar.component(.day, from: notificationDate)
        components.month = calendar.component(.month, from: notificationDate)
        components.year = calendar.component(.year, from: notificationDate)
        components.hour = 19
        notificationDate = calendar.date(from: components)!
                
        // Calculate the time interval and return it
        return notificationDate - self
    }
    
    func secondsUntilThisWeekend() -> Double {
        var notificationDate = self
        // If it is already Saturday morning (before 10am)
        let calendar = Calendar(identifier: .gregorian)
        let currentDay = calendar.component(.day, from: self)
        let currentHour = calendar.component(.hour, from: self)
        
        if currentDay == 7 && currentHour >= 10 {
            // It's already Saturday and past 10am so we need to skip to next saturday
            notificationDate = self.addingTimeInterval(604800)
        } else if currentDay == 7 {
            print("It's already Saturday.")
        } else {
            notificationDate = notificationDate.next(.saturday)
        }
        
        var components = DateComponents()
        components.day = calendar.component(.day, from: notificationDate)
        components.month = calendar.component(.month, from: notificationDate)
        components.year = calendar.component(.year, from: notificationDate)
        components.hour = 10
        notificationDate = calendar.date(from: components)!
                
        // Calculate the time interval and return it
        return notificationDate - self
    }
    
}




enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}
