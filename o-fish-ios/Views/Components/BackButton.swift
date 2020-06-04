//
//  BackButton.swift
//
//  Created on 25/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    var label: String = "Go Back"

    let spacing: CGFloat = 8

    var body: some View {
        HStack(spacing: spacing) {
            Image(systemName: "chevron.left")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.main)
            Text(LocalizedStringKey(label))
                .foregroundColor(.main)
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(label: "Back")
    }
}
