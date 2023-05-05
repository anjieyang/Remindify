//
//  MyList+CoreDataClass.swift
//  Remindify
//
//  Created by digmouse on 2023-05-03.
//

import Foundation
import CoreData

@objc(MyList)
public class MyList: NSManagedObject {
    var remindersArray: [Reminder] {
        reminders?.allObjects.compactMap{ ($0 as! Reminder) } ?? []
    }
}
