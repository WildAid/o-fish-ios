//
//  CheckBox.swift
//
//  Created on 27/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CheckBox: View {
    let title: String
    @Binding var value: Bool

    private enum Dimensions {
        static let spacing: CGFloat = 8
    }

    var body: some View {
        Button(action: {
            self.value.toggle()
        }) {
            HStack(spacing: Dimensions.spacing) {
                Image(systemName: self.value ? "checkmark.square" : "square")
                    .font(.body)
                    .foregroundColor(.oText)

                Text(LocalizedStringKey(title))
                    .lineLimit(1)
                    .foregroundColor(.oText)
                    .font(.body)
            }
        }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CheckBox(title: "Captain", value: .constant(true))
            CheckBox(title: "Captain", value: .constant(false))
        }
    }
}
