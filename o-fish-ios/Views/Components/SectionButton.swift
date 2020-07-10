//
//  SectionButton.swift
//
//  Created on 05/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct SectionButton: View {
    let title: String
    let systemImageName: String

    var callingToAction = true

    var colorPrimary: Color = .main
    var colorSecondary: Color = .removeAction

    let action: () -> Void

    private let spacing: CGFloat = 8.0

    var body: some View {
        Button(action: action) {
            HStack(spacing: spacing) {
                Image(systemName: systemImageName)
                Text(LocalizedStringKey(title))
            }
                .foregroundColor(currentColor)
                .font(.subheadline)
        }
    }

    var currentColor: Color {
        callingToAction ? colorPrimary : colorSecondary
    }
}

struct SectionButton_Previews: PreviewProvider {
    static var previews: some View {
       SectionButton(title: "Button",
                     systemImageName: "photo",
                     action: {})
    }
}
