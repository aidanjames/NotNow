//
//  AllRemindersView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 24/11/2020.
//

import SwiftUI

struct AllRemindersView: View {
    @StateObject var viewModel = AllRemindersViewModel()
    
    var body: some View {
        VStack {
            Button(action: { viewModel.showingAddNewReminder = true } ) {
                Text("Add new NotNow")
            }
            .fullScreenCover(isPresented: $viewModel.showingAddNewReminder) {
                AddReminderView(viewModel: viewModel)
            }
            
            ForEach(viewModel.allReminders) { reminder in
                Text("\(reminder.title)")
            }
        }
    }
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
