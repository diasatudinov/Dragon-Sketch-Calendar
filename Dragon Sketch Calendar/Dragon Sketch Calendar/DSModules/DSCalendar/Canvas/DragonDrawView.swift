//
//  DragonDrawView.swift
//  Dragon Sketch Calendar
//
//


import SwiftUI

struct DragonDrawView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: [AppRoute]
    
    let element: Elements
    let emotion: Emotion
    
    @State private var strokes: [DrawingStroke] = []
    @State private var currentPoints: [CGPoint] = []
    
    @State private var selectedTool: DrawingTool = .pen
    @State private var brushWidth: CGFloat = 6
    @State private var eraserWidth: CGFloat = 22
    
    @State private var dragon: Dragon?
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                topBar
                
                Spacer().frame(height: 18)
                
                thumbnailsRow
                
                Spacer().frame(height: 24)
                
                drawingArea
                
                Spacer()
                
                bottomBar
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 18)
        }
    }
    
    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color(hex: "#2A0202"),
                Color(hex: "#3B0606"),
                Color(hex: "#2A0202")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: "#FFD92D"))
                    .frame(width: 36, height: 36)
            }
            
            Spacer()
            
            Button {
                path.removeAll()
            } label: {
                Text("Complete")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .frame(height: 30)
                    .background(
                        Capsule()
                            .fill(Color.red)
                    )
            }
        }
    }
    
    private var thumbnailsRow: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                Button {
                    self.dragon = nil
                } label: {
                    Image("dragon1IconDS")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 55)
                        .opacity(0)
                        .padding()
                        .frame(width: 70)
                        .background {
                            Color.black.opacity(0.28)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            if self.dragon == nil {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.appYellow)
                            }
                        }
                }
                
                
                HStack {
                    ForEach(Dragon.allCases, id: \.self) { daragon in
                        Button {
                            self.dragon = daragon
                        } label: {
                            Image(daragon.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 55)
                                .padding()
                                .frame(width: 70)
                                .background {
                                    Color.black.opacity(0.28)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay {
                                    if self.dragon == daragon {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(.appYellow)
                                    }
                                }
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var drawingArea: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.clear)
                
                if let dragon {
                    Image(dragon.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 390)
                        .opacity(0.5)
                }
                
                Canvas { context, size in
                    let allStrokes = strokes + currentStroke
                    
                    for stroke in allStrokes {
                        let path = makePath(from: stroke.points, lineWidth: stroke.lineWidth)
                        
                        var copy = context
                        if stroke.tool == .eraser {
                            copy.blendMode = .destinationOut
                            copy.stroke(
                                path,
                                with: .color(.black),
                                style: StrokeStyle(
                                    lineWidth: stroke.lineWidth,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        } else {
                            copy.blendMode = .normal
                            copy.stroke(
                                path,
                                with: .color(stroke.color),
                                style: StrokeStyle(
                                    lineWidth: stroke.lineWidth,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        }
                    }
                }
                .compositingGroup()
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        currentPoints.append(value.location)
                    }
                    .onEnded { value in
                        var points = currentPoints
                        if points.isEmpty {
                            points = [value.location]
                        }
                        
                        let newStroke = DrawingStroke(
                            points: points,
                            color: element.color,
                            lineWidth: activeLineWidth,
                            tool: selectedTool
                        )
                        
                        strokes.append(newStroke)
                        currentPoints.removeAll()
                    }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var bottomBar: some View {
        HStack(spacing: 14) {
            Button {
                selectedTool = .pen
            } label: {
                ZStack {
                    Circle()
                        .fill(selectedTool == .pen ? Color.green.opacity(0.35) : Color.white.opacity(0.08))
                        .frame(width: 34, height: 34)
                    
                    Image(systemName: "pencil.tip")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selectedTool == .pen ? .green : .white.opacity(0.85))
                }
            }
            
            Divider()
                .frame(height: 28)
                .background(Color.white.opacity(0.16))
            
            Slider(
                value: Binding(
                    get: {
                        selectedTool == .pen ? brushWidth : eraserWidth
                    },
                    set: { newValue in
                        if selectedTool == .pen {
                            brushWidth = newValue
                        } else {
                            eraserWidth = newValue
                        }
                    }
                ),
                in: 2...40
            )
            .tint(Color.green.opacity(0.9))
            
            Divider()
                .frame(height: 28)
                .background(Color.white.opacity(0.16))
            
            Button {
                selectedTool = .eraser
            } label: {
                ZStack {
                    Circle()
                        .fill(selectedTool == .eraser ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
                        .frame(width: 34, height: 34)
                    
                    Image(systemName: "eraser")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            Button {
                strokes.removeAll()
                currentPoints.removeAll()
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 34, height: 34)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 58)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.35))
        )
    }
    
    private var activeLineWidth: CGFloat {
        selectedTool == .pen ? brushWidth : eraserWidth
    }
    
    private var currentStroke: [DrawingStroke] {
        guard !currentPoints.isEmpty else { return [] }
        
        return [
            DrawingStroke(
                points: currentPoints,
                color: element.color,
                lineWidth: activeLineWidth,
                tool: selectedTool
            )
        ]
    }
    
    private func makePath(from points: [CGPoint], lineWidth: CGFloat) -> Path {
        var path = Path()
        
        guard let first = points.first else { return path }
        
        if points.count == 1 {
            path.addEllipse(
                in: CGRect(
                    x: first.x - lineWidth / 2,
                    y: first.y - lineWidth / 2,
                    width: lineWidth,
                    height: lineWidth
                )
            )
            return path
        }
        
        path.move(to: first)
        
        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }
        
        for index in 1..<points.count {
            let previous = points[index - 1]
            let current = points[index]
            let midPoint = CGPoint(
                x: (previous.x + current.x) / 2,
                y: (previous.y + current.y) / 2
            )
            
            if index == 1 {
                path.addLine(to: midPoint)
            } else {
                path.addQuadCurve(to: midPoint, control: previous)
            }
            
            if index == points.count - 1 {
                path.addQuadCurve(to: current, control: current)
            }
        }
        
        return path
    }
}

enum DrawingTool {
    case pen
    case eraser
}

struct DrawingStroke: Identifiable {
    let id = UUID()
    let points: [CGPoint]
    let color: Color
    let lineWidth: CGFloat
    let tool: DrawingTool
}


#Preview {
    DragonDrawView(path: .constant([]), element: .wood, emotion: .one)
}
