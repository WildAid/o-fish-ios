//
//  ViolationPickerView.swift
//
//  Created on 3/13/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationPickerData {
    var id = UUID()

    let title: String
    let description: String
}

extension ViolationPickerData: SearchableDataProtocol {
    static let notSelected = ViolationPickerData(title: "", description: "")

    var searchKey: String {
        title + description
    }
}

struct ViolationPickerView: View {
    @Binding var selectedItem: ViolationPickerData
    private(set) var items: [ViolationPickerData]
    let title: String
    let searchBarPlaceholder: String

    var body: some View {
        SearchableView(selectedItem: $selectedItem,
            items: items,
            title: title,
            searchBarPlaceholder: searchBarPlaceholder) { (item: ViolationPickerData) in

                ViolationPickerDataView(title: item.title, description: item.description)
        }
    }
}

struct ViolationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let testItems = [ViolationPickerData(title: "Fish and game",
                                             description: "No license"),
                         ViolationPickerData(title: "Fish and game",
                                             description: "Use barbed hooks for Salmon"),
                         ViolationPickerData(title: "Fish and game",
                                             description: "Take in violation of Federal Regulations")]
        return ViolationPickerView(selectedItem: .constant(ViolationPickerData(title: "Title",
                                                                               description: "Description")),
                                   items: testItems,
                                   title: "Title",
                                   searchBarPlaceholder: "Placeholder")
    }
}
