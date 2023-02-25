////
//  TaskCell.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 09.02.2023.
//

import SwiftUI

struct TaskCell: View {
    
    private static let xOffsetThreshold: CGFloat = 200
    
    private let task: TaskModel
    private let onSwipeAction: (() -> Void)?
    
    @State private var isHovered: Bool = false
    @State private var offset: CGSize = .zero
    
    init(task: TaskModel, onSwipeAction: (() -> Void)? = nil) {
        self.task = task
        self.onSwipeAction = onSwipeAction
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Rectangle()
                .frame(width: 16, height: 16)
                .hidden()
            
            Image(systemName: "doc")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 16, height: 16)
            
            Text(task.title.isEmpty ? "Title" : task.title)
                .foregroundColor(task.title.isEmpty ? .white.opacity(0.5) : .white)
                .animation(.default, value: task.title)
            
            Spacer()
            
            Image(systemName: "info.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundColor(isHovered ? Color.white.opacity(0.8) : .clear)
        }
        .contentShape(Rectangle())
        .padding(12)
        .offset(offset)
        .font(.system(size: 12, weight: .medium))
        .lineLimit(3)
        .background(isHovered && offset.width == .zero ? Color.accentBlue : Color.clear)
        .background(offset.width == .zero ? .clear : .red.opacity(offset.width / Self.xOffsetThreshold))
        .animation(.easeOut(duration: 0.3), value: isHovered)
        .foregroundColor(Color(nsColor: NSColor.fromHEX(0xFFFFFF).withAlphaComponent(0.8)))
        .onHover { isHovered = $0 }
        .overlay(alignment: .leading) {
            Text("Remove?")
                .opacity((offset.width - 35) / Self.xOffsetThreshold)
                .padding(8)
        }
        .gesture(
            DragGesture(minimumDistance: 25)
                .onChanged { value in
                    offset.width = value.translation.width
                    offset.width = max(0, min(Self.xOffsetThreshold, offset.width))
                }
                .onEnded { value in
                    if offset.width >= Self.xOffsetThreshold {
                        onSwipeAction?()
                    } else {
                        offset = .zero
                    }
                }
        )
        .transition(.asymmetric(insertion: .identity, removal: .opacity.animation(.easeIn(duration: 0.3))))
    }
}
