//
//  DSCanvasView.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

struct DSCanvasView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
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
                    }
                }
                
                
                
                Spacer()
                
            }
            
            Spacer()
            
        }
        .background(Color.tab.opacity(0.95))
    }
}

#Preview {
    DSCanvasView()
}
