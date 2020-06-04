//
//  LabeledDoubleInput.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LabeledDoubleInput: View {
    var label: String
    @Binding var value: Double

    private enum Dimensions {
        static let noSpacing: CGFloat = 0.0
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        let valueBinding = Binding(
            get: { String(format: "%.8f", Double(self.value)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.value = value.doubleValue
                    print("New value: \(self.value)")
                } else {
                    print("Could not convert to number")
                }
            }
        )

        return VStack(alignment: .leading, spacing: Dimensions.noSpacing) {
            CaptionLabel(title: label)
            TextField(label, text: valueBinding)
                .foregroundColor(.black)
                .keyboardType(.decimalPad)
                .padding(.bottom, Dimensions.padding)
            Divider()
        }
    }
}

struct LabeledDoubleInput_Previews: PreviewProvider {
    static var previews: some View {
        LabeledDoubleInput(label: "Test Label", value: .constant(22.3763527237532))
    }
}
