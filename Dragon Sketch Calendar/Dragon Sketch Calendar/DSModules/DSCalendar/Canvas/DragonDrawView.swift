//
//  DragonDrawView.swift
//  Dragon Sketch Calendar
//
//


import SwiftUI

struct DragonDrawView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var strokes: [DrawingStroke] = []
    @State private var currentPoints: [CGPoint] = []
    
    @State private var selectedTool: DrawingTool = .pen
    @State private var brushWidth: CGFloat = 6
    @State private var eraserWidth: CGFloat = 22
    
    private let drawingColor = Color(red: 0.45, green: 1.0, blue: 0.65)
    
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
                // Здесь можно сохранить рисунок или закрыть экран
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
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "#D6A300"), lineWidth: 1)
                .frame(width: 50, height: 50)
            
            ForEach(0..<5, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.28))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "scribble")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.9))
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var drawingArea: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.clear)
                
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
                            color: drawingColor,
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
                color: drawingColor,
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
    DragonDrawView()
}
