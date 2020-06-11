//
//  RectangleButton.swift
//
//  Created on 11/06/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct RectangleButton: View {
    var title: String
    var action: (() -> Void)?

    var backgroundColor = Color.callToAction
    var foregroundColor = Color.white

    var spacing: CGFloat = 16

    var body: some View {
        Button(action: { self.action?() }) {
            HStack(spacing: .zero) {
                Spacer(minLength: spacing)
                Text(title)
                    .padding(.vertical, spacing)
                    .font(Font.body.weight(.semibold))
                    .foregroundColor(foregroundColor)
                Spacer(minLength: spacing)
            }
                .background(backgroundColor)
        }
    }
}

struct RectangleButton_Previews: PreviewProvider {
    static var previews: some View {
        RectangleButton(title: "Rectangle button")
    }
}
