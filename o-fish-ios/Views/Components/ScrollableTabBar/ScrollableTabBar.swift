//
//  ScrollableTabBar.swift
//
//  Created on 26/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class TabBarItem: ObservableObject {
    @Published var title: String
    @Published var state: State

    enum State {
        case notStarted
        case started
        case skipped
        case complete
    }

    init(title: String, state: State = .notStarted) {
        self.title = title
        self.state = state
    }
}

extension TabBarItem: Equatable {
    public static func == (lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension TabBarItem: Identifiable {
    public var id: String {
        title
    }
}

struct ScrollableTabBar: View {
    @Binding var items: [TabBarItem]
    let selectedItem: TabBarItem

    var itemClicked: ((TabBarItem) -> Void)?

    var tintColor = Color.main

    let noSpacing: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: noSpacing) {
                ForEach(items) { item in
                    ScrollableTabBarItemView(item: item,
                        isSelected: self.isSelected(item: item),
                        activeColor: self.tintColor,
                        onClick: self.itemClicked)
                }

                Spacer(minLength: noSpacing)
            }
        }
    }

    private func isSelected(item: TabBarItem) -> Bool {
        item.id == selectedItem.id
    }
}

struct ScrollableTabBar_Previews: PreviewProvider {
    static var previews: some View {
        let items = [TabBarItem(title: "Title1", state: .complete),
                      TabBarItem(title: "Title2", state: .complete),
                      TabBarItem(title: "Title3", state: .skipped),
                      TabBarItem(title: "Title4", state: .notStarted),
                      TabBarItem(title: "Title5", state: .notStarted)]

        return ScrollableTabBar(items: .constant(items), selectedItem: items[3])
    }
}
