//
//  ChooseViolationsView.swift
//
//  Created on 3/13/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ChooseViolationsView: View {
    let violations: [ViolationPickerData] = [
        ViolationPickerData(caption: "California",
            title: "Fish and Game code 7850(a)",
            description: "No Commercial License"),

        ViolationPickerData(caption: "California",
            title: "Fish and Game code 7145(a)",
            description: "Fishing without a license"),

        ViolationPickerData(caption: "California",
            title: "T-14 29.85(a)(7)",
            description: "Take/Possess undersize Dungeness crab"),

        ViolationPickerData(caption: "California",
            title: "T-14 189(a)",
            description: "Take in violation of Federal Regulations"),

        ViolationPickerData(caption: "California",
            title: "T-14 27.80(a)(2)",
            description: "Use barbed hooks for Salmon")
    ]

    @Binding var selectedItem: ViolationPickerData

    var body: some View {
        ViolationPickerView(selectedItem: $selectedItem,
            items: violations,
            title: "Violations",
            searchBarPlaceholder: "Search Violations")
    }
}

struct ChooseViolationsView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseViolationsView(selectedItem: .constant(ViolationPickerData(caption: "",
                                                                         title: "",
                                                                         description: "")))
    }
}
