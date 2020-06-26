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
        static let blurRadius: CGFloat = 6.0
        static let offsetPoint = CGPoint(x: 0, y: 0)
        static let spread: CGFloat = 4.0
    }

    let action: (() -> Void)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(Color.lightGrayButton)
                .frame(height: Dimensions.height + Dimensions.spread)
                .cornerRadius(.infinity)
                .blur(radius: Dimensions.blurRadius, opaque: false)

            Button(action: action,
                   label: {
                    HStack(spacing: Dimensions.spacing) {
                        Spacer()
                        Image("vesselIconButton")
                        Text("Board Vessel")
                            .font(.title2)
                            .lineLimit(1)
                        Spacer()
                    }
                    .foregroundColor(.main)
                    .frame(height: Dimensions.height)
            })
                .background(Color.white)
                .cornerRadius(.infinity)
                .padding(.horizontal, Dimensions.spread / 2)
                .shadow(color: .lightGrayButton,
                        radius: Dimensions.blurRadius / 2,
                        x: Dimensions.offsetPoint.x,
                        y: Dimensions.offsetPoint.y)

        }
    }
}

struct BoardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BoardButtonView(action: {})
    }
}
