//
//  ReminderCellView.swift
//  Remindify
//
//  Created by digmouse on 2023-05-04.
//

import SwiftUI

enum ReminderCellEvents {
    case onInfo
    case onCheckedChange(Reminder, Bool)
    case onSelect(Reminder)
}

struct ReminderCellView: View {
    let reminder: Reminder
    let isSelected: Bool
    let delay = Delay()
    
    @State private var isChecked: Bool = false

    let onEvent: (ReminderCellEvents) -> Void
    
    private func formatDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: isChecked ? "circle.inset.filled" : "circle")
                .font(.title2)
                .opacity(0.4)
                .onTapGesture {
                    isChecked.toggle()
                    
                    // cancel the old task
                    delay.cancel()
                    
                    // call onCheckedChange inside the delay
                    delay.performWork {
                        onEvent(.onCheckedChange(reminder, isChecked))
                    }
                }
            
            VStack(alignment: .leading) {
                Text(reminder.title ?? "")
                
                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .opacity(0.4)
                }
                
                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(formatDate(reminderDate))
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted(date: .omitted, time: .shortened))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                .opacity(0.4)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onEvent(.onSelect(reminder))
            }
            .onAppear {
                isChecked = reminder.isCompleted
            }
            Image(systemName: "info.circle")
                .foregroundColor(.blue)
                .opacity(isSelected ? 1.0 : 0.0)
                .font(.title3)
                .onTapGesture {
                    onEvent(.onInfo)
                }
        }
    }
}

struct ReminderCellView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderCellView(reminder: PreviewData.reminder, isSelected: false, onEvent: { _ in })
    }
}
