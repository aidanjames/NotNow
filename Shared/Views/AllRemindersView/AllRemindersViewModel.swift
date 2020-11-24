//
//  AllRemindersViewModel.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 24/11/2020.
//

import Foundation

class AllRemindersViewModel: ObservableObject {
    @Published var allReminders = [Reminder]()
    
    init() {
        allReminders = PersistenceManager.shared.fetchReminders()
    }
}
