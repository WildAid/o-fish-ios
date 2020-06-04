//
//  BoardButton.swift
//
//  Created on 3/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BoardButtonView: View {

    private enum Dimensions {
        static let height: CGFloat = 74.0
        static let spacing: CGFloat = 16.0
        static let shadowRadius: CGFloat = 5
        static let point = CGPoint(x: 0, y: 5)
    }

    let action: (() -> Void)

    var body: some View {
        Button(action: action,
               label: {
                HStack(spacing: Dimensions.spacing) {
                    Spacer()
                    Image("vesselIconButton")
                    Text("Board Vessel")
                        .lineLimit(1)
                    Spacer()
                }
                    .foregroundColor(.main)
                    .frame(height: Dimensions.height)
        })
            .background(Color.white)
            .cornerRadius(.infinity)
            .shadow(color: .gray,
                    radius: Dimensions.shadowRadius,
                    x: Dimensions.point.x,
                    y: Dimensions.point.y)
    }
}

struct BoardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BoardButtonView(action: {})
            .background(Color.black)
    }
}
