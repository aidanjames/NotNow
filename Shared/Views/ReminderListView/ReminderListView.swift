//
//  ReminderListView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 30/11/2020.
//

import SwiftUI

struct ReminderListView: View {
    var reminder: Reminder
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.2)
                .cornerRadius(16)
            VStack(alignment: .leading, spacing: 8) {
                Text("\(reminder.title)")
                    .font(.title3)
                    .bold()
                Spacer()
                Text("\(reminder.description)")
                Spacer()
                Text("Due: 25/04/2020")
                    .font(.caption)
                    .foregroundColor(.green)
                if !reminder.tags.isEmpty {
                    ScrollView(.horizontal) {
                        Text("Tags: \(reminder.tags.first!)")
                    }
                    .font(.caption)
                    .padding(0)
                }
            }
            .padding()
        }
        .frame(width: width, height: height)
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        let reminder = Reminder(reminderDates: [Date().addingTimeInterval(11111)], title: "Email Mitch", description: "Tell Mitch about the game this weekend and see if he's keen to go to the pub to watch.", scheduledReminders: [UUID().uuidString], tags: ["email"])
        return ReminderListView(reminder: reminder, width: 150, height: 150)
    }
}
