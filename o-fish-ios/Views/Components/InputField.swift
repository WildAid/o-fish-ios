//
//  InputField.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct InputField: View {
    @State var title = "Title"
    @Binding var text: String

    let tag: Int

    var showingSecureField = false
    var showingWarning = false

    var captionColor = Color.removeAction
    var separatorColor = Color.inactiveBar
    var warningColor = Color.spanishOrange

    var inputChanged: (() -> Void)?

    var autocapitalizationType: UITextAutocapitalizationType = .sentences
    var keyboardType: UIKeyboardType = .alphabet

    private enum Dimensions {
        static let noSpacing: CGFloat = 0
        static let bottomPadding: CGFloat = 16
        static let iconSize: CGFloat = 20
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {
            CaptionLabel(title: title, color: showingWarning ? warningColor : captionColor)

            HStack(spacing: Dimensions.noSpacing) {
                FocusableTextFieldAdapter(
                    tag: tag,
                    text: textBinding,
                    isSecure: showingSecureField,
                    keyboardType: keyboardType,
                    autocapitalizationType: autocapitalizationType)
                    .padding(.bottom, Dimensions.bottomPadding)

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

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InputField(title: "Input", text: .constant("Data"), tag: 0)
            InputField(title: "Input secure", text: .constant("Data"), tag: 1, showingSecureField: true)
            InputField(title: "Input with warning", text: .constant("Data"), tag: 2, showingWarning: true)
        }
    }
}
