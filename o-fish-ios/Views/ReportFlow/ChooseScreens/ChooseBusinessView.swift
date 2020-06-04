//
//  ChooseBusinessView.swift
//
//  Created on 4/2/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BusinessPickerData {
    var business: String
    var location: String
}

extension BusinessPickerData: SearchableDataProtocol {
    static let notSelected = BusinessPickerData(business: "", location: "")

    var id: String {
        business
    }

    var searchKey: String {
        business + location
    }
}

struct ChooseBusinessView: View {

    @Binding var selectedItem: BusinessPickerData
    @Binding var isAutofillItem: Bool
    @State private var searchText = ""
    @Environment(\.presentationMode) private var presentationMode

    private enum Dimensions {
        static let padding: CGFloat = 16.0
    }

    let items = [BusinessPickerData(business: "P. Sherman",
                                    location: """
                                                 42 Wallaby Way
                                                 Sydney NSW 2000
                                                 Australia
                                                 """),
                 BusinessPickerData(business: "H.B. Johnson",
                                    location: """
                                                 25 Green Str
                                                 Los Angeles LA 45
                                                 USA
                                                 """)]

    var body: some View {
        VStack {
            SearchBarView(searchText: $searchText, placeholder: "Choose Business")
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(items.filter {
                        $0.isMatch(search: searchText) || searchText == ""
                    }) { item in
                        Button(action: { self.searchItemClicked(item: item) }) {
                            BusinessPickerDataView(item: item)
                        }
                    }
                }
                VStack(alignment: .leading) {
                    SectionButton(title: "New Business", systemImageName: "plus") {
                        self.selectedItem = .notSelected
                        self.isAutofillItem = false
                        self.dismiss()
                    }

                    Divider()
                }
            }
            .padding(.horizontal, Dimensions.padding)
        }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private func searchItemClicked(item: BusinessPickerData) {
        selectedItem = item
        dismiss()
    }
}

struct ChooseBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedItem = BusinessPickerData(business: "P. Sherman", location: "Location")
        return ChooseBusinessView(selectedItem: .constant(selectedItem),
                                  isAutofillItem: .constant(true))
    }
}
