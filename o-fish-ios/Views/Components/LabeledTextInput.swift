//
//  LabeledBoxView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LabeledTextInput: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(label, text: $text)
        }
        .padding()
    }
}

struct LabeledTextInput_Previews: PreviewProvider {
    static var previews: some View {
        LabeledTextInput(label: "Test Input", text: .constant("Test text"))
    }
}
