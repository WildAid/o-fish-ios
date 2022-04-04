//
//  IconLabel.swift
//
//  Created on 3/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct IconLabel: View {

    let imagePath: String
    let title: String

    var color = Color.oBlue
    var horizontalPadding: CGFloat = 16.0

    private enum Dimension {
        static let spacing: CGFloat = 10.0
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: Dimension.spacing) {
                Image(systemName: imagePath)
                Text(LocalizedStringKey(title))
                    .font(.body)
                Spacer()
            }
                .foregroundColor(color)
        }
            .padding(.horizontal, horizontalPadding)
    }
}

struct SystemIconView_Previews: PreviewProvider {
    static var previews: some View {
        IconLabel(imagePath: "plus",
                      title: "Add New Vessel")
    }
}
