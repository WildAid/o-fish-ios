//
//  ChooseViolationsView.swift
//
//  Created on 3/13/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ChooseViolationsView: View {
    private var violations: [ViolationPickerData] {
        var list = [ViolationPickerData]()
        if Settings.shared.menuData.violationCodes.count == Settings.shared.menuData.violationDescriptions.count {
            for index in Settings.shared.menuData.violationCodes.indices {
                let violation = ViolationPickerData(
                    caption: "",
                    title: Settings.shared.menuData.violationCodes[index],
                    description: Settings.shared.menuData.violationDescriptions[index]
                )
                list.append(violation)
            }
        } else {
            print("Violation code and description lists have different lengths")
        }
        return list
    }

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
