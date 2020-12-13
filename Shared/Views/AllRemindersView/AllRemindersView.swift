//
//  AllRemindersView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 24/11/2020.
//

import SwiftUI

struct AllRemindersView: View {
    @StateObject var viewModel = AllRemindersViewModel()
    @State private var showingDeleteWarning = false
    @State private var tappedReminder: UUID?
    
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.allRemindersSorted) { reminder in
                        ReminderListView(viewModel: viewModel, reminder: reminder, height: 120)
                            .onTapGesture {
                                tappedReminder = reminder.id
                                showingDeleteWarning = true
                            }
                            .alert(isPresented: $showingDeleteWarning) {
                                Alert(
                                    title: Text("Are you sure you want to delete this?"),
                                    message: Text("There is no undo"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        withAnimation {
                                            viewModel.deleteReminder(id: tappedReminder!)
                                        }
                                    },
                                    secondaryButton: .cancel())
                            }
                    }
                }
                .padding(.horizontal, 10)
            }
            .fullScreenCover(isPresented: $viewModel.showingAddNewReminder) {
                AddReminderView(viewModel: viewModel)
            }
            .navigationTitle("NotNow").foregroundColor(Color(Colours.midnightBlue))
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
        .accentColor(Color(Colours.hotCoral))
    }
    
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
