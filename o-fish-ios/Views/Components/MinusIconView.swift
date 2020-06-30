//
//  MinusIconView.swift
//
//  Created on 23/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct MinusIconView: View {

    private enum Dimensions {
        static let padding: CGFloat = 3.0
        static let imageSize: CGFloat = 20.0
        static let cirleSize: CGFloat = 15.0
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: Dimensions.cirleSize, height: Dimensions.cirleSize)

            Image(systemName: "minus.circle.fill")
                .font(.system(size: Dimensions.imageSize))
                .foregroundColor(Color.red)
        }
            .padding(.vertical, Dimensions.padding)
    }
}

struct MinusIconView_Previews: PreviewProvider {
    static var previews: some View {
        MinusIconView()
            .background(Color.black)
    }
}
