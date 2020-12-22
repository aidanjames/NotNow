//
//  ReminderListView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 30/11/2020.
//

import SwiftUI

struct ReminderListView: View {
    @ObservedObject var viewModel: AllRemindersViewModel
    @Binding var showingSnoozeActionSheet: Bool
    var reminder: Reminder
    var height: CGFloat
    
    @State private var isOverdue = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.2)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(Colours.hotCoral), lineWidth: isOverdue ? 1 : 0)
                )
            HStack {
                Button(action: { toggleCompletedForReminder() }) {
                    Image(systemName: reminder.completed ? "checkmark.circle.fill" : "circle")
                        .font(.largeTitle)
                        .padding(5)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(reminder.title)")
                        .font(.title2)
                        .bold()
                        .layoutPriority(1)
                    HStack {
                        Text(reminder.nextDueDate == Date.futureDate ? "Due: Someday" : reminder.nextDueDate == Date.completedDate ? "Completed" : "Due: \(reminder.nextDueDate.friendlyDate())")
                            .foregroundColor(reminder.nextDueDate < Date() ? Color(Colours.hotCoral) : Color(Colours.midnightBlue))
                        if !reminder.notifications.isEmpty && !isOverdue {
                            Image(systemName: "clock")
                                .foregroundColor(Color(Colours.hotCoral))
                        } else if isOverdue {
                            Button(action: {
                                viewModel.tappedReminder = reminder.id
                                showingSnoozeActionSheet = true
                            } ) {
                                HStack(spacing: 2) {
                                    Text("Snooze")
                                    Image(systemName: "zzz")
                                }
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color(Colours.hotCoral))
                                .cornerRadius(16)
                            }
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
                Button(action: {
                    viewModel.tappedReminder = reminder.id
                    showingSnoozeActionSheet.toggle()
                } ) {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .rotationEffect(.degrees(90))
                        .foregroundColor(Color(Colours.hotCoral))
                }
                .padding()
            }
            .foregroundColor(Color(Colours.midnightBlue))
        }
        .frame(height: height)
        .opacity(reminder.completed ? 0.5 : 1.0)
        .onReceive(timer) { date in
            if date > reminder.nextDueDate {
                isOverdue = true
            } else {
                isOverdue = false
            }
        }
    }
    
    func toggleCompletedForReminder() {
        if let index = viewModel.allReminders.firstIndex(where: { $0.id == reminder.id }) {
            withAnimation {
                viewModel.allReminders[index].completed.toggle()
                viewModel.allReminders[index].nextDueDate = Date.completedDate
            }
            viewModel.updateReminder(reminder: viewModel.allReminders[index], notificationDates: [])
        }
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        let reminder = Reminder(title: "Email Mitch about a dog", description: "Tell Mitch about the game this weekend and see if he's keen to go to the pub to watch.", tags: ["email"], nextDueDate: Date(), notifications: [UUID().uuidString: Date().addingTimeInterval(11111)])
        return ReminderListView(viewModel: AllRemindersViewModel(), showingSnoozeActionSheet: .constant(false), reminder: reminder, height: 150)
    }
}
