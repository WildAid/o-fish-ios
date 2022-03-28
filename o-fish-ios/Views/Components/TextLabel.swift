//
//  TextLabel.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct TextLabel: View {
    var title: String
    var color: Color = .oText

    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .font(.body)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .foregroundColor(color)
            Spacer()
        }
    }
}

struct TextLabel_Previews: PreviewProvider {
    static var previews: some View {
        TextLabel(title: "Title")
    }
}
