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

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func friendlyDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }

} 
