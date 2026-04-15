//
//  DSCalendarView.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

enum AppRoute: Hashable {
    case preparation
    case draw(Emotion, Elements, String)
}

struct DestinyCalendarView: View {
    @ObservedObject var viewModel: DestinyCalendarViewModel
    @Binding var path: [AppRoute]
    
    var body: some View {
            ZStack {
                Color.tab.opacity(0.95)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    headerView
                    
                    Spacer().frame(height: 56)
                    
                    monthSwitcher
                    
                    Spacer().frame(height: 22)
                    
                    weekDaysHeader
                    
                    Spacer().frame(height: 10)
                    
                    calendarGrid
                    
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.top, 22)
            }
            
        
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Destiny Calendar")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "#FFD92D"))
            
            Text("Your day, your dragon.")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
        }
    }
    
    private var monthSwitcher: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.showPreviousMonth()
            } label: {
                monthArrow(systemName: "chevron.left")
            }
            
            Spacer().frame(width: 26)
            
            Text(viewModel.monthTitle)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Spacer().frame(width: 26)
            
            Button {
                viewModel.showNextMonth()
            } label: {
                monthArrow(systemName: "chevron.right")
            }
            
            Spacer()
        }
    }
    
    private func monthArrow(systemName: String) -> some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#5A0903"))
                .frame(width: 34, height: 34)
            
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#FFD92D"))
        }
    }
    
    private var weekDaysHeader: some View {
        let columns = Array(repeating: GridItem(.fixed(38), spacing: 14), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.weekdaySymbols, id: \.self) { day in
                Text(day)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#FFD92D"))
                    .frame(width: 38)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var calendarGrid: some View {
        let columns = Array(repeating: GridItem(.fixed(38), spacing: 14), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(viewModel.days) { day in
                Button {
                    if viewModel.state(for: day.date) == .today {
                        path.append(.preparation)
                    }
                } label: {
                    DayCellView(
                        day: day,
                        state: viewModel.state(for: day.date),
                        isCurrentMonth: day.isCurrentMonth
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Day Cell

private struct DayCellView: View {
    let day: CalendarDayItem
    let state: DayCellState
    let isCurrentMonth: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(day.dayNumberText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(dayNumberColor)
                .frame(width: 38)
            
            cellContent
                .frame(width: 38, height: 38)
        }
        .opacity(isCurrentMonth ? 1 : 0)
    }
    
    @ViewBuilder
    private var cellContent: some View {
        switch state {
        case .today:
           
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color(hex: "#A11311"))
                
                RoundedRectangle(cornerRadius: 9)
                    .stroke(.white.opacity(0.9), lineWidth: 1.2)
                
                Text("Draw")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            
        case .drawn:
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color(hex: "#7F0D08"))
                
                // Замени на свой asset дракона, если нужно:
                // Image("dragon_icon")
                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color(hex: "#2B0907"))
            }
            
        case .empty:
            RoundedRectangle(cornerRadius: 9)
                .fill(Color(hex: "#7F0D08"))
            
        case .future:
            RoundedRectangle(cornerRadius: 9)
                .fill(Color(hex: "#7F0D08").opacity(0.65))
        }
    }
    
    private var dayNumberColor: Color {
        isCurrentMonth ? .white : .white.opacity(0.65)
    }
}

#Preview {
    NavigationStack {
        DestinyCalendarView(viewModel: DestinyCalendarViewModel(), path: .constant([]))
    }
}
