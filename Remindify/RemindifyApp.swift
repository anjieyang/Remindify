//
//  RemindifyApp.swift
//  Remindify
//
//  Created by digmouse on 2023-05-03.
//

import SwiftUI
import UserNotifications

@main
struct RemindifyApp: App {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                
            } else {
                
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
        }
    }
}
