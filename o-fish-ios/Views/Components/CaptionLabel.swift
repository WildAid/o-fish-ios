//
//  CaptionLabel.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CaptionLabel: View {
    var title = "Title"
    var color: Color = .removeAction
    var font: Font = .caption1

    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .font(font)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .foregroundColor(color)
            Spacer()
        }
    }
}

struct CaptionLabel_Previews: PreviewProvider {
    static var previews: some View {
        CaptionLabel(title: "Caption Label")
    }
}
