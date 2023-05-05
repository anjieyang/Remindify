//
//  RemindifyApp.swift
//  Remindify
//
//  Created by digmouse on 2023-05-03.
//

import SwiftUI

@main
struct RemindifyApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
        }
    }
}
