//
//  MinusIconView.swift
//
//  Created on 23/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct MinusIconView: View {

    private enum Dimensions {
        static let padding: CGFloat = 12
        static let imageSize: CGFloat = 16.0
    }

    var body: some View {
        Image(systemName: "minus.circle.fill")
            .font(.system(size: Dimensions.imageSize))
            .foregroundColor(Color.red)
            .padding(.top, Dimensions.padding)
    }
}

struct MinusIconView_Previews: PreviewProvider {
    static var previews: some View {
        MinusIconView()
    }
}
