//
//  DSMenuView.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

struct BSMenuContainer: View {
    
    @AppStorage("firstOpenBB") var firstOpen: Bool = true
    var body: some View {
        NavigationStack {
            ZStack {
                DSMenuView()
            }
        }
    }
}

struct DSMenuView: View {
    @StateObject private var viewModel = DestinyCalendarViewModel()
    @State var selectedTab = 0
    private let tabs = ["Calendar", "Archive", "Analytics"]
    @State private var path: [AppRoute] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                
                TabView(selection: $selectedTab) {
                    DestinyCalendarView(viewModel: viewModel, path: $path)
                        .tag(0)
                    
                    DSArchiveView(viewModel: viewModel)
                        .tag(1)
                    
                    Color.blue
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                customTabBar
            }
            .background(
                .tab.opacity(0.95)
            )
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .preparation:
                    DSPreparationView(viewModel: viewModel, path: $path)
                        .navigationBarBackButtonHidden()
                    
                case .draw(let emotion, let element, let description):
                    DragonDrawView(viewModel: viewModel, path: $path, element: element, emotion: emotion, description: description)
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    VStack(spacing: 4) {
                        Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 36)
                        
                        Text(tabs[index])
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(selectedTab == index ? .appYellow : .appGray)
                            .padding(.bottom, 10)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.tab)
        .padding(.bottom, 5)
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconBS"
        case 1: return "tab2IconBS"
        case 2: return "tab3IconBS"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedBS"
        case 1: return "tab2IconSelectedBS"
        case 2: return "tab3IconSelectedBS"
        default: return ""
        }
    }
}

#Preview {
    BSMenuContainer()
}
