//
//  InputMultilineField.swift
//
//  Created on 06/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct InputMultilineField: View {
    @Binding var text: String

    private let spacing: CGFloat = 16.0

    var body: some View {
        VStack(spacing: spacing) {
            MultilineTextView(text: $text)
            Divider()
        }
    }
}

struct InputMultilineField_Previews: PreviewProvider {
    static var previews: some View {
        InputMultilineField(text: .constant("Chips"))
    }
}
