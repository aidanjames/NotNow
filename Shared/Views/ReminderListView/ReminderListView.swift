//
//  ReminderListView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 30/11/2020.
//

import SwiftUI

struct ReminderListView: View {
    var reminder: Reminder
    //    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.2)
                .cornerRadius(16)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Image(systemName: "clock")
                }
                Text("\(reminder.title)")
                    .font(.title3)
                    .bold()
                    .layoutPriority(1)
                Text("\(reminder.description)")
                    .font(.caption)
                    .padding(.vertical)
                Text("Due: 25/04/2020")
                    .font(.caption)
                if !reminder.tags.isEmpty {
                    ScrollView(.horizontal) {
                        ForEach(reminder.tags, id: \.self) { tag in
                            TagView(tagName: tag, font: .caption)
                        }
                    }
                    .font(.caption)
                    .padding(5)
                }
            }
            .padding()
            
        }
        .frame(height: height)
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        let reminder = Reminder(reminderDates: [Date().addingTimeInterval(11111)], title: "Email Mitch", description: "Tell Mitch about the game this weekend and see if he's keen to go to the pub to watch.", scheduledReminders: [UUID().uuidString], tags: ["email"])
        return ReminderListView(reminder: reminder, height: 150)
    }
}
