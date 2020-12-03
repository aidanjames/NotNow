//
//  AllRemindersView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 24/11/2020.
//

import SwiftUI

struct AllRemindersView: View {
    @StateObject var viewModel = AllRemindersViewModel()
    
    let columns = [
//        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            BaseView()
            Color(.white)
                .opacity(0.9)
                .ignoresSafeArea()
            VStack {
                Button(action: { viewModel.showingAddNewReminder = true } ) {
                    Text("Add new NotNow")
                        .frame(width: 280, height: 50)
                        .background(Color.green)
                        .cornerRadius(16)
                        .foregroundColor(.white)
                }
                .fullScreenCover(isPresented: $viewModel.showingAddNewReminder) {
                    AddReminderView(viewModel: viewModel)
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.allReminders) { reminder in
                            ReminderListView(reminder: reminder, height: 150)
                        }
                    }
                    .padding(.horizontal, 10)
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
