//
//  ReminderDetailView.swift
//  Remindify
//
//  Created by digmouse on 2023-05-04.
//

import SwiftUI

struct ReminderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var reminder: Reminder
    
    // the default edit config should be the same as the original config
    @State var reminderEditConfig: ReminderEditConfig
    
    private var isFormValid: Bool {
        !reminderEditConfig.title.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("Title", text: $reminderEditConfig.title)
                        TextField("Notes", text: $reminderEditConfig.notes ?? "")
                    }
                    
                    Section {
                        Toggle(isOn: $reminderEditConfig.hasDate) {
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                        }
                        
                        if reminderEditConfig.hasDate {
                            DatePicker("Select Date", selection: $reminderEditConfig.reminderDate ?? Date(), displayedComponents: .date)
                        }
                        
                        Toggle(isOn: $reminderEditConfig.hasTime) {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }
                        
                        if reminderEditConfig.hasTime {
                            DatePicker("Select Time", selection: $reminderEditConfig.reminderTime ?? Date(), displayedComponents: .hourAndMinute)
                        }
                        
                        NavigationLink {
                            SelectListView(selectedList: $reminder.list)
                        } label: {
                            HStack {
                                Text("List")
                                Spacer()
                                Text(reminder.list!.name)
                            }
                        }
                    }
                    .onChange(of: reminderEditConfig.hasDate) { hasDate in
                        if hasDate {
                            reminderEditConfig.reminderDate = Date()
                        }
                    }
                    .onChange(of: reminderEditConfig.hasTime) { hasTime in
                        if hasTime {
                            reminderEditConfig.reminderTime = Date()
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .onAppear {
                reminderEditConfig = ReminderEditConfig(reminder: reminder)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Details")
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        do {
                            let updated = try RemindifyService.updateReminder(reminder: reminder, reminderEditConfig: reminderEditConfig)
                            if updated {
                                if reminder.reminderDate != nil || reminder.reminderTime != nil {
                                    let userData = UserData(title: reminder.title, body: reminder.notes, date: reminder.reminderDate, time: reminder.reminderTime)
                                    NotificationManager.scheduleNotification(userData: userData)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

struct ReminderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetailView(reminder: .constant(PreviewData.reminder), reminderEditConfig: ReminderEditConfig(reminder: PreviewData.reminder))
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
