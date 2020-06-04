//
//  LabeledText.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LabeledText: View {
    var label: String
    var text: String

    let lineLimit = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CaptionLabel(title: label)
            Text("\(text)")
                .lineLimit(lineLimit)
        }
    }
}

struct LabeledText_Previews: PreviewProvider {
    static var previews: some View {
        LabeledText(label: "Label", text: "0.72367628765")
    }
}
