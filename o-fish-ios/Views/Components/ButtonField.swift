//
//  ButtonField.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ButtonField: View {
    let title: String
    let text: String

    var showingWarning = false

    var captionColor = Color.removeAction
    var separatorColor = Color.inactiveBar
    var warningColor = Color.spanishOrange

    let fieldButtonClicked: (() -> Void)?

    private enum Dimensions {
        static let noSpacing: CGFloat = 0
        static let bottomPadding: CGFloat = 16
        static let textMinHeight: CGFloat = 21.5
    }

    var body: some View {
        Button(action: { self.fieldButtonClicked?() }) {
            VStack(spacing: Dimensions.noSpacing) {
                CaptionLabel(title: title, color: showingWarning ? warningColor : captionColor)

                HStack(spacing: Dimensions.noSpacing) {
                    TextLabel(title: text)
                        .frame(minHeight: Dimensions.textMinHeight)
                        .padding(.bottom, Dimensions.bottomPadding)
                        .font(.body)

                    if showingWarning {
                        ExclamationIconView()
                    }
                }

                Divider()
                    .background(showingWarning ? warningColor : separatorColor)
            }
        }
    }
}

struct ButtonField_Previews: PreviewProvider {
    static var previews: some View {
        ButtonField(title: "Button Title", text: "Some text\nSomeText\nSomeText\nSomeText\nSomeText\nSomeText", fieldButtonClicked: {})
    }
}
