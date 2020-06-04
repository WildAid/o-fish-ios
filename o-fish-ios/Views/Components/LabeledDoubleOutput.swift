//
//  LabeledDoubleOutput.swift
//
//  Created on 3/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LabeledDoubleOutput: View {
    var label: String
    @Binding var value: Double

    var body: some View {
        VStack(spacing: 4) {
            Text(LocalizedStringKey(label))
                .font(.caption)
            TextField(label,
                text:
                Binding(
                    get: { String(format: "%.7f", Double(self.value)) },
                    set: {
                        guard let value = NumberFormatter().number(from: $0) else {
                            return
                        }
                        self.value = value.doubleValue
                    })
            )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .disabled(true)
        }
    }
}

struct LabeledDoubleOutput_Previews: PreviewProvider {
    static var previews: some View {
        LabeledDoubleOutput(label: "Test Label", value: .constant(22.3763527237532))
    }
}
