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
    
 
    func notificationCategoryToUse() -> NotificationCategory {
        let calendar = Calendar(identifier: .gregorian)
        let currentDay = calendar.component(.weekday, from: self)
        let currentHour = calendar.component(.hour, from: self)
        // Is it a weekend?
        if currentDay == 7 || currentDay == 1 {
            if currentHour >= 18 {
                // Is a weekend and is in the evening
                return .weekendAfternoon
            } else {
                // Is a weekend but not past 18:00
                return .weekendDay
            }
        } else if currentHour >= 18 {
            // It's a weekday and is in the evening
            return .weekdayAfternoon
        } else {
            // It's a weekday but not past 18:00
            return .weekdayDay
        }

    }
    
    
    func thisEvening() -> Date {
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
        return calendar.date(from: components)!
    }
    
    
    func tomorrowMorning() -> Date {
        // Create a Date object for tomorrow @ 10am
        let thisTimeTomorrow = self.addingTimeInterval(86400)
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.day = calendar.component(.day, from: thisTimeTomorrow)
        components.month = calendar.component(.month, from: thisTimeTomorrow)
        components.year = calendar.component(.year, from: thisTimeTomorrow)
        components.hour = 10
        return calendar.date(from: components)!
    }
    
    
    func saturdayMorning() -> Date {
        let closestSaturday = self.next(.saturday)
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.day = calendar.component(.day, from: closestSaturday)
        components.month = calendar.component(.month, from: closestSaturday)
        components.year = calendar.component(.year, from: closestSaturday)
        components.hour = 10
        return calendar.date(from: components)!
    }
    
    
    func notificationDateComponents() -> DateComponents {
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return comps
    }
    
}




enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}
