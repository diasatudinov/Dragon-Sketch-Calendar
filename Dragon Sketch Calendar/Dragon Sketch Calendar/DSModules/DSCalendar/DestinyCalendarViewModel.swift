//
//  DestinyCalendarViewModel.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

// MARK: - ViewModel

final class DestinyCalendarViewModel: ObservableObject {
    @Published var displayedMonth: Date
    @Published var draws: [Draw]
    
    let calendar: Calendar
    private let storage = DrawsStorage()
    init(draws: [Draw] = []) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.firstWeekday = 1 // Sunday
        
        self.calendar = calendar
        self.displayedMonth = calendar.startOfMonth(for: Date())
        self.draws = storage.load().sorted { $0.date < $1.date }
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
    
    func showPreviousMonth() {
        guard let date = calendar.date(byAdding: .month, value: -1, to: displayedMonth) else { return }
        displayedMonth = calendar.startOfMonth(for: date)
    }
    
    func showNextMonth() {
        guard let date = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else { return }
        displayedMonth = calendar.startOfMonth(for: date)
    }
    
    // MARK: - Draws
    
    /// Если в один день должен быть только один рисунок,
    /// то при добавлении новый рисунок заменит старый за этот день.
    func add(draw: Draw) {
        if let index = draws.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: draw.date) }) {
            draws[index] = draw
        } else {
            draws.append(draw)
        }
        
        draws.sort { $0.date < $1.date }
        storage.replaceAll(with: draws)
    }
    
    func delete(draw: Draw) {
        draws.removeAll { $0.id == draw.id }
        storage.replaceAll(with: draws)
    }
    
    func deleteDraw(on date: Date) {
        draws.removeAll { calendar.isDate($0.date, inSameDayAs: date) }
        storage.replaceAll(with: draws)
    }
    
    func draw(for date: Date) -> Draw? {
        draws.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func hasDraw(on date: Date) -> Bool {
        draw(for: date) != nil
    }
    
    func state(for date: Date) -> DayCellState {
        let today = calendar.startOfDay(for: Date())
        let currentDay = calendar.startOfDay(for: date)
        
        if calendar.isDate(currentDay, inSameDayAs: today) {
            return .today
        }
        
        if currentDay < today {
            return hasDraw(on: currentDay) ? .drawn : .empty
        }
        
        return .empty
    }
}
