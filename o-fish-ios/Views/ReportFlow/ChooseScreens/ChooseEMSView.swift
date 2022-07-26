//
//  EMSTypeList.swift
//
//  Created on 3/2/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit
import SwiftUI

struct ChooseEMSView: View {

    private var items: [String] {
        var array = [String]()
        for type in Settings.shared.menuData.emsTypes {
            array.append(type)
        }
        return array
    }

    @Binding var selectedItem: String

    var body: some View {
        TextPickerView(selectedItem: $selectedItem,
            items: items,
            title: UIScreen.isWidthAtLeast6 ? "Electronic Monitoring System" : "EMS",
            searchBarPlaceholder: "Search EMS's")
    }
}

struct ChooseEMSView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseEMSView(selectedItem: .constant("Other"))
    }
}
