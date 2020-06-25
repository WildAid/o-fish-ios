//
//  CaptionLabel.swift
//
//  Created on 24/02/2020.
//

import SwiftUI

struct TitleLabel: View {
    var title = "Title"
    var color: Color = .black

    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundColor(color)
                .font(Font.title3.weight(.semibold))
            Spacer()
        }
    }
}

struct TitleLabel_Previews: PreviewProvider {
    static var previews: some View {
        return TitleLabel()
    }
}
