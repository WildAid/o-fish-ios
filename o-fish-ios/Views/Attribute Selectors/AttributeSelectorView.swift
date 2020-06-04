//
//  AttributeSelectorView.swift
//
//  Created on 18/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AttributeSelectorView: View {
    let settings = Settings.shared
    var menuType: MenuType
    var label: String
    @Binding var value: String
    @State private var showingOther = true

    var body: some View {
        let valueBinding = Binding<Int>(
            get: {
                self.settings.menuDataList.getOptionId(menuType: self.menuType, string: self.value)
            },

            set: {
                self.value = self.settings.menuDataList.getOptionString(menuType: self.menuType, index: $0)
                if self.value == "Other" {
                    self.showingOther = true
                    self.value = ""
                } else {
                    self.showingOther = false
                }
            }
        )

        return VStack {
            Picker(label, selection: valueBinding) {
                ForEach(0..<settings.menuDataList.optionCount(menuType), id: \.self) { index in
                    Text(self.settings.menuDataList.getOptionString(menuType: self.menuType, index: index))
                }
            }

            if self.showingOther {
                TextField(label, text: $value)
            }
        }
    }
}

struct AttributeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: Pass in example environment
        AttributeSelectorView(menuType: MenuType.countryPickerPriorityList, label: "Flag State", value: .constant("Legoland"))
    }
}
