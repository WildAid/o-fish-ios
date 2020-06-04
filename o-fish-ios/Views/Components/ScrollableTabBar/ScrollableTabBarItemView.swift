//
//  ScrollableTabBarItemView.swift
//
//  Created on 08/05/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ScrollableTabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool

    var activeColor = Color.main

    var notStartedLineColor = Color.inactiveBar
    var notStartedTitleColor = Color.removeAction
    var skippedColor = Color.spanishOrange
    var completeColor = Color.main

    var onClick: ((TabBarItem) -> Void)?

    private enum Configuration {
        static let padding: CGFloat = 16.0
        static let highlightOpacity = 0.1

        static let inactiveSeparatorHeight: CGFloat = 2
        static let activeSeparatorHeight: CGFloat = 4

        static let iconSize: CGFloat = 20
        static let noSpacing: CGFloat = 0
        static let lineLimit = 1
    }

    var body: some View {
        Button(action: { self.onClick?(self.item) }) {
            VStack(spacing: Configuration.noSpacing) {
                HStack {
                    Text(LocalizedStringKey(item.title))
                        .padding(Configuration.padding)
                        .lineLimit(Configuration.lineLimit)
                        .font(titleFont)
                        .foregroundColor(titleColor)
                }

                lineColor
                    .frame(height: Configuration.inactiveSeparatorHeight)

// TODO: fixme correct image overlaying over Z index or overlay
//                if !isSelected {
//                    Image(systemName: statusImageName)
//                        .font(.system(size: Configuration.iconSize))
//                        .foregroundColor(titleColor)
//                }
            }
                .fixedSize()
                .overlay(activeColor
                    .frame(height: Configuration.activeSeparatorHeight)
                    .opacity(isSelected ? 1 : 0),
                    alignment: .bottom)
        }
            .background(isSelected ? activeColor.opacity(Configuration.highlightOpacity) : .clear)
    }

    private var statusImageName: String {
        if item.state == .skipped {
            return "exclamationmark.circle.fill"
        }
        if item.state == .complete {
            return "checkmark.circle.fill"
        }
        return ""
    }

    private var titleFont: Font {
        (isSelected || item.state != .notStarted) ? Font.body.weight(.semibold) : Font.body
    }

    private var titleColor: Color {
        if isSelected {
            return activeColor
        } else {
            switch item.state {
            case .complete:
                return activeColor
            case .notStarted:
                return notStartedTitleColor
            case .skipped, .started:
                return skippedColor
            }
        }
    }

    private var lineColor: Color {
        switch item.state {
        case .complete:
            return activeColor
        case .notStarted:
            return notStartedLineColor
        case .skipped, .started:
            return skippedColor
        }
    }
}

struct ScrollableTabBarItemView_Previews: PreviewProvider {
    static let items = [TabBarItem(title: "Title1", state: .complete),
                         TabBarItem(title: "Title2", state: .complete),
                         TabBarItem(title: "Title3", state: .skipped),
                         TabBarItem(title: "Title4", state: .notStarted),
                         TabBarItem(title: "Title5", state: .notStarted)]

    static var previews: some View {
        VStack {
            ForEach(items) { item in
                ScrollableTabBarItemView(item: item, isSelected: item.title == "Title5")
            }
        }
    }
}
