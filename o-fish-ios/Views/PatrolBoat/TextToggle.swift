//
//  TextToggle.swift
//
//  Created on 3/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct TextToggle: View {
    @Binding var isOn: Bool

    let titleLabel: String
    let onLabel: String
    let offLabel: String

    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(ColoredToggleStyle(
                label: titleLabel,
                onInsideLabel: onLabel,
                offInsideLabel: offLabel,
                onColor: .main)
            )
    }
}

struct TextToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextToggle(isOn: .constant(false),
                       titleLabel: "Test",
                       onLabel: "At Sea",
                       offLabel: "On Land")
            Divider()
            TextToggle(isOn: .constant(true),
                       titleLabel: "Test",
                       onLabel: "At Sea",
                       offLabel: "On Land")

        }
    }
}
