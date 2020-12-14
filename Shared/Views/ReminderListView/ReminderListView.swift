//
//  ReminderListView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 30/11/2020.
//

import SwiftUI

struct ReminderListView: View {
    @ObservedObject var viewModel: AllRemindersViewModel
    @Binding var showingActionSheet: Bool
    @Binding var tappedReminder: UUID?
    var reminder: Reminder
    var height: CGFloat
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.2)
                .cornerRadius(16)
            HStack {
                Button(action: { toggleCompletedForReminder() }) {
                    Image(systemName: reminder.completed ? "checkmark.circle.fill" : "circle")
                        .font(.largeTitle)
                        .padding(5)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(reminder.title)")
                        .font(.title)
                        .bold()
                        .layoutPriority(1)
                    HStack {
                        Text("Due: \(reminder.nextDueDate == Date.futureDate ? "Someday" : reminder.nextDueDate.friendlyDate()) ")
                        if !reminder.notifications.isEmpty {
                            Image(systemName: "clock")
                                .foregroundColor(Color(Colours.hotCoral))
                        }
                    }.font(.caption)
                    if !reminder.tags.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(Array(reminder.tags), id: \.self) { tag in
                                    TagView(tagName: tag, font: .caption)
                                }
                            }
                        }
                        .font(.caption)
                        .padding(5)
                    }
                }
                Spacer()
            }
            .foregroundColor(Color(Colours.midnightBlue))
            HStack {
                Spacer()
                Button(action: {
                    tappedReminder = reminder.id
                    showingActionSheet.toggle()
                } ) {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .rotationEffect(.degrees(90))
                        .foregroundColor(Color(Colours.hotCoral))
                }
                .padding()
            }
        }
        .frame(height: height)
        .opacity(reminder.completed ? 0.5 : 1.0)
        .onAppear {
            print(reminder.tags)
        }
    }
    
    func toggleCompletedForReminder() {
        if let index = viewModel.allReminders.firstIndex(where: { $0.id == reminder.id }) {
            viewModel.allReminders[index].completed.toggle()
            
            if viewModel.allReminders[index].completed && !viewModel.allReminders[index].notifications.isEmpty {
                viewModel.allReminders[index].cancelAllScheduledReminders()
            }
            
            viewModel.updateReminder(reminder: viewModel.allReminders[index])
        }
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        let reminder = Reminder(title: "Email Mitch", description: "Tell Mitch about the game this weekend and see if he's keen to go to the pub to watch.", tags: ["email"], nextDueDate: Date(), notifications: [UUID().uuidString: Date().addingTimeInterval(11111)])
        return ReminderListView(viewModel: AllRemindersViewModel(), showingActionSheet: .constant(false), tappedReminder: .constant(nil), reminder: reminder, height: 150)
    }
}
