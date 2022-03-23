//
//  InputMultilineFieldCaption.swift
//
//  Created on 17/07/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct InputMultilineFieldCaption: View {
    @State var title = "Title"
    @Binding private(set) var text: String

    var showingWarning = false

    var captionColor = Color.removeAction
    var separatorColor = Color.inactiveBar
    var warningColor = Color.spanishOrange

    var textInputHeight: CGFloat = 100

    var inputChanged: (() -> Void)?

    var autocorrectionType: UITextAutocorrectionType = .default

    var body: some View {
        VStack(spacing: .zero) {
            CaptionLabel(title: title, color: showingWarning ? warningColor : captionColor)

            HStack(spacing: .zero) {
                MultilineTextView(text: textBinding,
                                  autocorrectionType: autocorrectionType)
                    .frame(minHeight: textInputHeight)

                if showingWarning {
                    ExclamationIconView()
                }
            }

            Divider()
                .background(showingWarning ? warningColor : separatorColor)
        }
    }

    var textBinding: Binding<String> {
        Binding<String>(get: {
            self.text
        }, set: {
            self.text = $0
            self.inputChanged?()
        })
    }
}

struct InputMultilineFieldCaption_Previews: PreviewProvider {
    static var previews: some View {
        InputMultilineFieldCaption(text: .constant("Line1\nLine2\nLine3\nLine4"))
    }
}
