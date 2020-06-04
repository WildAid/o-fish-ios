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

    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .font(.caption)
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
