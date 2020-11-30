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
        ZStack {
            BaseView()
            Color(.white)
                .opacity(0.9)
                .ignoresSafeArea()
            VStack {
                Button(action: { viewModel.showingAddNewReminder = true } ) {
                    Text("Add new NotNow")
                }
                .fullScreenCover(isPresented: $viewModel.showingAddNewReminder) {
                    AddReminderView(viewModel: viewModel)
                }
                
                ForEach(viewModel.allReminders) { reminder in
                    ReminderListView(reminder: reminder, width: 150, height: 150)
                }
            }
        }
    }
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
