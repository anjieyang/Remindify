//
//  NotificationManager.swift
//  Remindify
//
//  Created by digmouse on 2023-05-05.
//

import Foundation
import UserNotifications

struct UserData {
    let title: String?
    let body: String?
    let date: Date?
    let time: Date?
}

class NotificationManager {
    static func scheduleNotification(userData: UserData) {
        let content = UNMutableNotificationContent()
        content.title = userData.title ?? ""
        content.body = userData.body ?? ""
        
        var dateComponenets = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: userData.date ?? Date())
        
        if let reminderTime = userData.time {
            let remidnerTimeDateComponents = reminderTime.dateComponents
            dateComponenets.hour = remidnerTimeDateComponents.hour
            dateComponenets.minute = remidnerTimeDateComponents.minute
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponenets, repeats: false)
        let request = UNNotificationRequest(identifier: "Remindify Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
