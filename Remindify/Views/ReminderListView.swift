//
//  ReminderListView.swift
//  Remindify
//
//  Created by digmouse on 2023-05-04.
//

import SwiftUI

struct ReminderListView: View {
    @State private var selectedReminder: Reminder?
    @State private var showReminderDetail: Bool = false
    let reminders: FetchedResults<Reminder>
    
    private func reminderCheckedChanged(reminder: Reminder, isCompleted: Bool) {
        var reminderEditConfig = ReminderEditConfig(reminder: reminder)
        reminderEditConfig.isCompleted = isCompleted
        
        do {
            let _ = try RemindifyService.updateReminder(reminder: reminder, reminderEditConfig: reminderEditConfig)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        selectedReminder?.objectID == reminder.objectID
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminder = reminders[index]
            do {
                try RemindifyService.deleteReminder(reminder: reminder)
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(reminders, id: \.self) { reminder in
                    ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { reminderCellEvent in
                        switch reminderCellEvent {
                            case .onInfo:
                                showReminderDetail = true
                            case .onCheckedChange(let reminder, let isCompleted):
                                reminderCheckedChanged(reminder: reminder, isCompleted: isCompleted)
                            case .onSelect(let reminder):
                                selectedReminder = reminder
                        }
                    }
                }
                .onDelete(perform: deleteReminder)
            }
        }
        .sheet(isPresented: $showReminderDetail) {
            ReminderDetailView(reminder: Binding($selectedReminder)!, reminderEditConfig: ReminderEditConfig(reminder: selectedReminder!))
        }
    }
}

struct ReminderListView_Preview: PreviewProvider {
    struct ReminderListViewContainer: View {
        @FetchRequest(sortDescriptors: [])
        private var reminderResults: FetchedResults<Reminder>
        
        var body: some View {
            ReminderListView(reminders: reminderResults)
        }
    }
    
    static var previews: some View {
        ReminderListViewContainer()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
