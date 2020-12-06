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
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                BaseView()
                Color(.white)
                    .opacity(0.9)
                    .ignoresSafeArea()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.allRemindersSorted) { reminder in
                            ReminderListView(reminder: reminder, height: 170)
                                .onTapGesture {
                                    viewModel.deleteReminder(id: reminder.id)
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .fullScreenCover(isPresented: $viewModel.showingAddNewReminder) {
                    AddReminderView(viewModel: viewModel)
                }
            }
            .navigationTitle("NotNow")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.showingAddNewReminder = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            }
            
        }
        .accentColor(.green)
    }
    
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
