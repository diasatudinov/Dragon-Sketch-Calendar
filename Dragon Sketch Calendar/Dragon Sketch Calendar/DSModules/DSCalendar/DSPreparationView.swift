//
//  DSPreparationView.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

struct DSPreparationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DestinyCalendarViewModel
    @Binding var path: [AppRoute]
    
    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "LLLL dd, yyyy"
        return formatter.string(from: Date.now).capitalized
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    @State private var emotion: Emotion = .one
    @State private var element: Elements?
    @State private var description: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 14)
                                    .bold()
                                    .foregroundStyle(.textYellow)
                                
                                Text("Preparation")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(.textYellow)
                            }
                        }
                        
                        
                        
                        Spacer()
                        
                    }
                    
                    Text("For \(monthTitle)")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        Text("How do you feel today?")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.textYellow)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(Emotion.allCases, id: \.rawValue) { item in
                                Button {
                                    emotion = item
                                } label: {
                                    Text(item.emoji)
                                        .font(.system(size: 32, weight: .bold))
                                        .padding(15)
                                        .background {
                                            Color.emojiBg.opacity(0.2)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            if self.emotion == item {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundStyle(.textYellow)
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .background {
                            Color.tab
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                    }
                    .padding(.top, 24)
                    
                    VStack {
                        Text("Choose an element")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.textYellow)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Elements.allCases, id: \.rawValue) { element in
                                    
                                    Button {
                                        self.element = element
                                    } label: {
                                        VStack(spacing: 6) {
                                            
                                            Image(element.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 36)
                                            
                                            Text(element.text)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundStyle(element.color)
                                            
                                        }
                                        .frame(width: 113)
                                        .padding(.vertical, 17)
                                        .background {
                                            element.color.opacity(0.2)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            if self.element == element {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(lineWidth: 2)
                                                    .foregroundStyle(element.color)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    
                    if let element {
                        VStack(spacing: 12) {
                            Text("Guidance")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(element.color)
                                .textCase(.uppercase)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\"\(element.guidance)\"")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(.appGray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack {
                                Text("What will you do with this emotion?")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(element.color)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextField("Write your intention...", text: $description)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.appGray)
                                    .padding(16)
                                    .padding(.vertical, 8)
                                    .background(element.color.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay {
                                        if description.isEmpty {
                                            Text("Write your intention...")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundStyle(.appGray)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .allowsHitTesting(false)
                                                .padding()
                                        }
                                    }
                                
                            }
                            
                        }
                        .padding(16)
                        .padding(.vertical, 8)
                        .background(element.color.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.top, 24)
                        
                        Button {
                            path.append(.draw(emotion, element, description))
                            
                        } label: {
                            Text("Start Drawing")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 13)
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 60))
                        }
                    }
                    
                    
                }
                .padding(.horizontal, 24)
            }
            
        }
        .background(Color.tab.opacity(0.95))
        
    }
}

#Preview {
    DSPreparationView(viewModel: DestinyCalendarViewModel(), path: .constant([]))
}
