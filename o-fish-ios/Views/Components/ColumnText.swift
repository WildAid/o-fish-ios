//
//  ColumnText.swift
//
//  Created on 4/13/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ColumnText: View {
    let title: String
    let subtitle: String

    private enum Dimensions {
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        VStack {
            Text(title)
                .font(Font.title.weight(.semibold))
            Text(subtitle)
                .font(.caption1)
        }
            .padding([.horizontal], Dimensions.padding)
    }
}

struct ColumnText_Previews: PreviewProvider {
    static var previews: some View {
        ColumnText(title: "Title",
                   subtitle: "Subtitle")
    }
}
