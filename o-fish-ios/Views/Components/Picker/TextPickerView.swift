//
//  TextSearchView.swift
//
//  Created on 17/03/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

extension String: SearchableDataProtocol {
    static let notSelected = ""

    var searchKey: String {
        self
    }
}

struct TextPickerView: View {
    @Binding var selectedItem: String
    private(set) var items: [String]
    let title: String
    let searchBarPlaceholder: String
    var isSearchBarVisible: Bool = true

    private let verticalPadding: CGFloat = 20

    var body: some View {
        SearchableView(selectedItem: _selectedItem,
            items: items,
            title: title,
            searchBarPlaceholder: searchBarPlaceholder,
            isSearchBarVisible: self.isSearchBarVisible) { (item: String) in

            HStack {
                Text(LocalizedStringKey(item))
                    .lineLimit(2)
                    .foregroundColor(.text)
                    .font(.body)
                Spacer()
            }
                .padding(.vertical, self.verticalPadding)
        }
    }
}

struct TextPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let items = ["1", "2", "3", "4", "5"]
        return TextPickerView(selectedItem: .constant("1"),
                              items: items, title: "Title",
                              searchBarPlaceholder: "Placholder")
    }
}
