//
//  BottomSheetView.swift
//  
//  Created on 26.05.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import SwiftUI

enum BottomSheetState {
    case hidden
    case half
    case open
}

struct BottomSheetView<Content: View>: View {

    @Binding var state: BottomSheetState

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let onDismiss: () -> Void
    let content: Content

    private let radius: CGFloat = 16
    private let indicatorHeight: CGFloat = 6
    private let indicatorWidth: CGFloat = 35
    private let snapRatio: CGFloat = 0.1
    private let minHeightRatio: CGFloat = 0.3

    init(state: Binding<BottomSheetState>, maxHeight: CGFloat, @ViewBuilder content: () -> Content, onDismiss: @escaping () -> Void) {
        self.minHeight = maxHeight * minHeightRatio
        self.maxHeight = maxHeight
        self.onDismiss = onDismiss
        self.content = content()
        self._state = state
    }

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: state)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    if value.location.y > geometry.size.height * 0.8 {
                        self.onDismiss()
                        self.state = .hidden
                    } else if (geometry.size.height * 0.4...geometry.size.height * 0.8).contains(value.location.y) {
                        self.state = .half
                    } else {
                        self.state = .open
                    }
                }
            )
        }
    }

    private var offset: CGFloat {
        switch state {
        case .hidden:
            return maxHeight + 50
        case .half:
            return maxHeight / 2
        case .open:
            return 50
        }
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: indicatorHeight / 2)
            .fill(Color.secondary)
            .frame(width: indicatorWidth, height: indicatorHeight)
    }
}
