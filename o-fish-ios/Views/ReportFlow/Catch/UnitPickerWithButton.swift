//
//  UnitPickerWithButton.swift
//
//  Created on 06/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct UnitPickerWithButton: View {
    typealias UnitSpecification = CatchViewModel.UnitSpecification

    var options = UnitSpecification.allCases
    @Binding var unit: UnitSpecification
    @State var selectButtonTitle: String = "Select"

    var selectButtonClicked: (() -> Void)?

    private enum Dimensions {
        static let buttonHeight: CGFloat = 54.0
    }

    var body: some View {
        VStack {
            Button(action: { self.selectButtonClicked?() }) {
                HStack {
                    Spacer()
                    Text(LocalizedStringKey(selectButtonTitle))
                    Spacer()
                }
                    .frame(height: Dimensions.buttonHeight)
                    .background(Color.main)
                    .foregroundColor(.white)
            }
            Picker("", selection:
                Binding<String>(
                    get: { self.unit.rawValue },
                    set: {
                        self.unit = UnitSpecification(rawValue: $0) ?? .notSelected
                    })
            ) {
                ForEach(options.map {$0.rawValue}) { option in
                    Text(LocalizedStringKey(option))
                }
            }
                .labelsHidden()
        }
    }
}

struct UnitPickerWithButton_Previews: PreviewProvider {
    static var previews: some View {
        UnitPickerWithButton(unit: .constant(.kilograms))
    }
}
