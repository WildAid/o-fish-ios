//
//  SearchableView.swift
//
//  Created on 17/03/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

protocol Unselectable {
    associatedtype Item

    static var notSelected: Item { get }
}

protocol SearchMatchable {
    var searchKey: String { get }

    func isMatch(search: String) -> Bool
}

extension SearchMatchable {
    func isMatch(search: String) -> Bool {
        searchKey.lowercased().contains(search.lowercased())
    }
}

protocol SearchableDataProtocol: SearchMatchable & Identifiable & Unselectable {
}

struct SearchableView<SearchableData: SearchableDataProtocol,
                     SearchableDataView: View>: View {

    @Environment(\.presentationMode) private var presentationMode
    @Binding private(set) var selectedItem: SearchableData
    @State private(set) var searchText = ""
    private(set) var items: [SearchableData]
    let title: String
    private(set) var cancelButtonTitle = "Cancel"
    let searchBarPlaceholder: String
    private(set) var isSearchBarVisible = true
    let viewForItem: (_: SearchableData) -> SearchableDataView

    private let horizontalPadding: CGFloat = 16

    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Text("\(title)")
                        .font(Font.callout.weight(.semibold))
                    HStack {
                        Button(action: cancelTabBarClicked) {
                            Text("Cancel")
                        }
                        Spacer()
                    }
                }
            }
            .padding([.top, .horizontal])

            if isSearchBarVisible {
                SearchBarView(searchText: $searchText, placeholder: searchBarPlaceholder)
            }

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(items.filter {
                        $0.isMatch(search: searchText) || searchText == ""
                    }) { item in

                        VStack(spacing: 0) {
                            Button(action: { self.searchItemClicked(item: item) }) {
                                self.viewForItem(item)
                            }
                            Divider()
                        }
                    }

                    Spacer()
                }
                    .padding(.horizontal, horizontalPadding)
            }
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("\(title)", displayMode: .inline)
            .navigationBarItems(leading: Button(action: cancelTabBarClicked) {
                Text("\(cancelButtonTitle)")
            })
    }

    private func searchItemClicked(item: SearchableData) {
        selectedItem = item
        presentationMode.wrappedValue.dismiss()
    }

    private func cancelTabBarClicked() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SearchableView_Previews: PreviewProvider {
    static var previews: some View {
        let items = ["1", "2", "3", "4", "5"]
        return SearchableView(selectedItem: .constant("1"),
                              items: items, title: "Title",
                              searchBarPlaceholder: "Placeholder") { count in
                                Text("\(count)")
        }
    }
}
