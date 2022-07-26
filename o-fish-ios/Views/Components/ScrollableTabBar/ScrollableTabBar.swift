//
//  ScrollableTabBar.swift
//
//  Created on 26/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class TabBarItem: ObservableObject, Identifiable {
    let id: Int
    @Published var title: String
    @Published var state: State

    enum State {
        case notStarted
        case started
        case skipped
        case complete
    }

    init(id: Int, title: String, state: State = .notStarted) {
        self.id = id
        self.title = title
        self.state = state
    }
}

extension TabBarItem: Equatable {
    public static func == (lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct ScrollableTabBar: View {
    @Binding var items: [TabBarItem]
    let selectedItem: TabBarItem

    var itemClicked: ((TabBarItem) -> Void)?

    var tintColor = Color.oBlue

    let noSpacing: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                HStack(spacing: noSpacing) {
                    ForEach(items) { item in
                        ScrollableTabBarItemView(item: item,
                                                 isSelected: self.isSelected(item: item),
                                                 activeColor: self.tintColor,
                                                 onClick: { item in
                            self.itemClicked?(item)
                            value.scrollTo(item.id, anchor: .center)
                        })
                        .id(item.id)
                    }

                    Spacer(minLength: noSpacing)
                }
            }
        }
        .background(Color.oBackground)
    }

    private func isSelected(item: TabBarItem) -> Bool {
        item.id == selectedItem.id
    }
}

struct ScrollableTabBar_Previews: PreviewProvider {
    static var previews: some View {
        let items = [TabBarItem(id: 0, title: "Title1", state: .complete),
                     TabBarItem(id: 1, title: "Title2", state: .complete),
                      TabBarItem(id: 2, title: "Title3", state: .skipped),
                      TabBarItem(id: 3, title: "Title4", state: .notStarted),
                      TabBarItem(id: 4, title: "Title5", state: .notStarted)]

        return ScrollableTabBar(items: .constant(items), selectedItem: items[3])
    }
}
