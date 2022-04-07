//
//  PickerField.swift
//  
//  Created on 04.04.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import SwiftUI

struct UnitPickerField: View {
    let title: String
    var options: [CatchViewModel.UnitSpecification]
    @Binding var unit: CatchViewModel.UnitSpecification

    var showingWarning = false

    var captionColor = Color.removeAction
    var separatorColor = Color.inactiveBar
    var warningColor = Color.spanishOrange

    private enum Dimensions {
        static let noSpacing: CGFloat = 0
        static let bottomPadding: CGFloat = 16
        static let textMinHeight: CGFloat = 21.5
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {
            CaptionLabel(title: title, color: showingWarning ? warningColor : captionColor)

            Picker("", selection: $unit) {
                ForEach(0..<options.count) { index in
                    TextLabel(title: options[index].rawValue, color: .oText)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .frame(maxWidth: .infinity, alignment: .leading)

        Divider()
            .background(showingWarning ? warningColor : separatorColor)

        }
    }
}

struct PickerField_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
