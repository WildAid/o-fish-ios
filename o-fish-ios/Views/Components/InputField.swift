//
//  InputField.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct InputField: View {
    @State var title = "Title"
    @Binding private(set) var text: String

    var showingSecureField = false
    var showingWarning = false
    var captionColor = Color.removeAction
    var separatorColor = Color.inactiveBar
    var warningColor = Color.spanishOrange
    var inputChanged: ((String) -> Void)?

    private enum Dimensions {
        static let noSpacing: CGFloat = 0
        static let bottomPadding: CGFloat = 16
        static let iconSize: CGFloat = 20
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {
            CaptionLabel(title: title, color: showingWarning ? warningColor : captionColor)

            HStack(spacing: Dimensions.noSpacing) {
                if !showingSecureField {
                    TextField("", text: textBinding)
                        .padding(.bottom, Dimensions.bottomPadding)
                        .foregroundColor(.text)
                        .font(.body)
                } else {
                    SecureField("", text: textBinding)
                        .padding(.bottom, Dimensions.bottomPadding)
                        .foregroundColor(.text)
                        .font(.body)
                }
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
            self.inputChanged?($0)
        })
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InputField(title: "Input", text: .constant("Data"))
            InputField(title: "Input secure", text: .constant("Data"), showingSecureField: true)
            InputField(title: "Input with warning", text: .constant("Data"), showingWarning: true)
        }
    }
}
