//
//  CallToActionButton.swift
//
//  Created on 27/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CallToActionButton: View {
    let title: String
    var showingArrow = false
    let action: () -> Void

    private enum Dimensions {
        static let labelSpacing: CGFloat = 14
        static let lineLimit = 1
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer(minLength: Dimensions.labelSpacing)
                Text(LocalizedStringKey(title))
                    .padding(.vertical, Dimensions.labelSpacing)
                    .lineLimit(Dimensions.lineLimit)
                    .font(Font.body.weight(.semibold))
                if showingArrow {
                    Image(systemName: "arrow.right")
                        .font(Font.caption2.weight(.bold))
                }
                Spacer(minLength: Dimensions.labelSpacing)
            }
                .foregroundColor(.white)
                .background(Color.callToAction)
                .cornerRadius(.infinity)
        }
    }
}

struct CallToActionButton_Previews: PreviewProvider {
    static var previews: some View {
        CallToActionButton(title: "Button", showingArrow: true, action: {})
    }
}
