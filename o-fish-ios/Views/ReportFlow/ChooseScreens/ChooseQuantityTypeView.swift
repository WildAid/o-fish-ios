//
//  ChooseQuantityTypeView.swift
//
//  Created on 3/4/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ChooseQuantityTypeView: View {
    typealias QuantityType = CatchViewModel.QuantityType

    @Binding var selectedItem: [QuantityType]

    var items: [[QuantityType]] = [
        [.weight], [.count], [.weight, .count]
    ]

    var body: some View {
        TextPickerView(selectedItem:
            Binding<String>(
                get: { self.selectedItem.map { $0.rawValue }.joined(separator: QuantityType.separator) },
                set: {
                    let arrayOfStrings = $0.components(separatedBy: QuantityType.separator)
                    let weightArray = arrayOfStrings.map {
                        QuantityType(rawValue: $0) ?? .notSelected
                    }
                    self.selectedItem = weightArray
            }),
            items: items.map { $0.map { $0.rawValue }.joined(separator: QuantityType.separator) },
            title: "Species",
            searchBarPlaceholder: "Search Species",
            isSearchBarVisible: false)
    }
}

struct ChooseQuantityTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseQuantityTypeView(selectedItem: .constant([.weight, .count]))
    }
}
