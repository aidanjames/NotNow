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
        Text("There are \(viewModel.allReminders.count) reminders.")
    }
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AllRemindersView()
    }
}
