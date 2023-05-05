//
//  RemindifyService.swift
//  Remindify
//
//  Created by digmouse on 2023-05-03.
//

import Foundation
import CoreData
import UIKit

class RemindifyService {
    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.persistentContainer.viewContext
    }
    
    static func save() throws {
        try viewContext.save()
    }
    
    static func saveMyList(name: String, color: UIColor) throws {
        let myList = MyList(context: viewContext)
        myList.name = name
        myList.color = color
        try save()
    }
    
    static func saveReminderToMyList(myList: MyList, reminderTitle: String) throws {
        let reminder = Reminder(context: viewContext)
        reminder.title = reminderTitle
        myList.addToReminders(reminder)
        try save()
    }
    
    static func updateReminder(reminder: Reminder, reminderEditConfig: ReminderEditConfig) throws -> Bool {
        let reminderToUpdate = reminder
        reminderToUpdate.title = reminderEditConfig.title
        reminderToUpdate.notes = reminderEditConfig.notes
        reminderToUpdate.isCompleted = reminderEditConfig.isCompleted
        reminderToUpdate.reminderDate = reminderEditConfig.hasDate ? reminderEditConfig.reminderDate : nil
        reminderToUpdate.reminderTime = reminderEditConfig.hasTime ? reminderEditConfig.reminderTime : nil
        try save()
        return true
    }
    
    static func deleteReminder(reminder: Reminder) throws {
        viewContext.delete(reminder)
        try save()
    }
    
    static func getRemindersByList(myList: MyList) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "list = %@ AND isCompleted = false", myList)
        return request
    }
    
    static func getRemindersBySearchTerm(searchTerm: String) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchTerm)
        return request
    }
    
    static func getRemindersByStatType(reminderStatType: ReminderStatType) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        
        switch reminderStatType {
            case .today:
                let today = Date()
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            request.predicate = NSPredicate(format: "(reminderDate >= %@) AND (reminderDate <= %@)", today as NSDate, tomorrow! as NSDate)
            case .scheduled:
                request.predicate = NSPredicate(format: "(reminderDate != nil OR reminderTime != nil) AND isCompleted = false")
            case .all:
                request.predicate = NSPredicate(format: "isCompleted = false")
            case .completed:
                request.predicate = NSPredicate(format: "isCompleted = true")
        }
        
        return request
    }
}
