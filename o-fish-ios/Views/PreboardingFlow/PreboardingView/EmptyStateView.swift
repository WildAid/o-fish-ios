//
//  EmptyStateView.swift
//
//  Created on 5/18/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    var searchWord = ""

    private enum Dimensions {
        static let spacing: CGFloat = 32.0
        static let imageSize: CGFloat = 100.0
        static let topPadding: CGFloat = 40.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: Dimensions.imageSize))
                .foregroundColor(Color.iconsGray)
            Text("No Results for “\(searchWord)“")
                .font(Font.title3.weight(.semibold))
        }
            .padding(.top, Dimensions.topPadding)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(searchWord: "Predat")
    }
}
