//
//  Date+Extensions.swift
//  Remindify
//
//  Created by digmouse on 2023-05-04.
//

import Foundation

extension Date {
    var isToday: Bool {
        let calender = Calendar.current
        return calender.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        let calender = Calendar.current
        return calender.isDateInTomorrow(self)
    }
    
    var dateComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
    
    var dayInString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }
}
