//
//  DSArchiveView.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

struct DSArchiveView: View {
    @ObservedObject var viewModel: DestinyCalendarViewModel
    @State private var selectedElement: Elements?
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
    
    private var filteredDraws: [Draw] {
        guard let selectedElement else {
            return viewModel.draws
        }
        
        return viewModel.draws.filter { $0.element == selectedElement }
    }
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Scroll Archive")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textYellow)
                
                Text("Your journey preserved.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                
                Button {
                    selectedElement = nil
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        
                        Text("All")
                        
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(selectedElement == nil ? .tab : .white)
                    .padding(7)
                    .padding(.horizontal, 9)
                    .background {
                        selectedElement == nil ? .white : Color.tab
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Elements.allCases, id: \.self) { element in
                            Button {
                                selectedElement = element
                            } label: {
                                HStack(spacing: 4) {
                                    
                                    Image(element.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 16)
                                    
                                    Text(element.rawValue.capitalized)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(selectedElement == element ? .tab : .white)
                                }
                                .padding(7)
                                .padding(.horizontal, 9)
                                .background {
                                    selectedElement == element ? .white : Color.tab
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                               
                            }
                        }
                    }
                }
            }
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(filteredDraws, id: \.id) { draw in
                        
                        VStack(spacing: 16) {
                           
                            
                            if let image = draw.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                            
                            VStack(spacing: 6) {
                                HStack(spacing: 6) {
                                    Text("\(draw.emotion.emoji)")
                                        .font(.system(size: 13, weight: .regular))
                                    
                                    Image(draw.element.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 16)
                                    
                                    Text("\(draw.element.text)")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.appGray)
                                }
                                
                                
                                Text("\(monthTitle(date: draw.date))")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.appGray)
                            }
                        }
                        .padding(.vertical, 16)
                        .frame(width: UIScreen.main.bounds.width / 2 - 35)
                        .background(.tab)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 2)
                                .foregroundStyle(draw.element.color)
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(Color.tab.opacity(0.95))
    }
    
    private func monthTitle(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "LLLL dd, yyyy"
        return formatter.string(from: date).capitalized
    }
}

#Preview {
    DSArchiveView(viewModel: DestinyCalendarViewModel())
}
