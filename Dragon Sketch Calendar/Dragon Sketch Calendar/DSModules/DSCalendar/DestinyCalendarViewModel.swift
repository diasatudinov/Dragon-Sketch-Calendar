//
//  DestinyCalendarViewModel.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

// MARK: - ViewModel

final class DestinyCalendarViewModel: ObservableObject {
    @Published var displayedMonth: Date
    @Published private(set) var drawnDates: Set<Date> = []
    
    let calendar: Calendar
    
    init() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.firstWeekday = 1 // Sunday
        
        self.calendar = calendar
        self.displayedMonth = calendar.startOfMonth(for: Date())
        
        // Пример моковых нарисованных дней
        let today = calendar.startOfDay(for: Date())
    }
    
    var weekdaySymbols: [String] {
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
    
    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: displayedMonth).capitalized
    }
    
    var days: [CalendarDayItem] {
        let monthStart = calendar.startOfMonth(for: displayedMonth)
        let weekdayOfFirst = calendar.component(.weekday, from: monthStart)
        let leadingDays = (weekdayOfFirst - calendar.firstWeekday + 7) % 7
        
        guard let gridStartDate = calendar.date(byAdding: .day, value: -leadingDays, to: monthStart) else {
            return []
        }
        
        return (0..<42).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: gridStartDate) else {
                return nil
            }
            
            let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
            
            return CalendarDayItem(
                date: date,
                isCurrentMonth: isCurrentMonth,
                calendar: calendar
            )
        }
    }
    
    func state(for date: Date) -> DayCellState {
        let day = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())
        
        if calendar.isDate(day, inSameDayAs: today) {
            return .today
        } else if day < today {
            return drawnDates.contains(day) ? .drawn : .empty
        } else {
            return .future
        }
    }
    
    func showPreviousMonth() {
        guard let date = calendar.date(byAdding: .month, value: -1, to: displayedMonth) else { return }
        displayedMonth = calendar.startOfMonth(for: date)
    }
    
    func showNextMonth() {
        guard let date = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else { return }
        displayedMonth = calendar.startOfMonth(for: date)
    }
}
