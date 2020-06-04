//
//  CountryPickerView.swift
//
//  Created on 11/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CountryPickerData {
    var image: String
    var title: String
}

extension CountryPickerData: SearchableDataProtocol {
    static let notSelected = CountryPickerData(image: "", title: "")

    var id: String {
        title
    }

    var searchKey: String {
        title
    }
}

struct CountryPickerView: View {
    @Binding var selectedItem: CountryPickerData
    private(set) var items: [CountryPickerData]
    let title: String
    let searchBarPlaceholder: String

    var body: some View {
        SearchableView(selectedItem: $selectedItem,
                       items: items,
                       title: title,
                       searchBarPlaceholder: searchBarPlaceholder) { (item: CountryPickerData) in

                        CountryPickerDataView(item: item)
        }
    }
}

struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let items = [CountryPickerData(image: "FR", title: "France"),
                     CountryPickerData(image: "NL", title: "Netherlands"),
                     CountryPickerData(image: "PL", title: "Poland")]

        return CountryPickerView(selectedItem: .constant(CountryPickerData(image: "FR",
                                                                           title: "France")),
                                 items: items,
                                 title: "Title" ,
                                 searchBarPlaceholder: "Placeholder" )
    }
}
