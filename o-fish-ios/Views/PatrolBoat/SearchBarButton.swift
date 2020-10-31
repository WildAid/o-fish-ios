//
//  SearchBarButton.swift
//
//  Created on 3/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct SearchBarButton: View {

    var title: String
    let action: (() -> Void)

    private enum Dimensions {
        static let paddingLeadingImage: CGFloat = 2.0
        static let height: CGFloat = 36.0
        static let cornerRadius: CGFloat = 10.0
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                GlassIconView()
                    .padding(.leading, Dimensions.paddingLeadingImage)
                Text(LocalizedStringKey(title))
                    .font(.body)
                Spacer()
            }
                .frame(height: Dimensions.height)
                .foregroundColor(.gray)
                .background(Color.oWeakOverlay)
                .cornerRadius(Dimensions.cornerRadius)
                .padding(.horizontal, Dimensions.padding)
        }
    }
}

struct SearchBarButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarButton(title: "Title", action: {})
    }
}
