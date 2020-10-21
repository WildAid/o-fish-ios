//
//  BoardVesselButtonView.swift
//  
//  Created on 9/8/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BoardVesselButtonView: View {

    var action: (() -> Void)?

    private enum Dimensions {
        static let heightSpacer: CGFloat = 3.0
        static let whiteCircleSize: CGFloat = 84.0
        static let blueCircleSize: CGFloat = 66.0
        static let widthImage: CGFloat = 32.0
        static let heightImage: CGFloat = 36.0
        static let offset: CGFloat = 5.0
        static let topPadding: CGFloat = 68.0
    }

    var body: some View {
        Button(action: action ?? {}) {
            VStack(spacing: .zero) {
                ZStack {
                    VStack {
                        Spacer()
                            .frame(height: Dimensions.heightSpacer)
                        Circle()
                            .fill(Color.oAltBackground)
                            .frame(width: Dimensions.whiteCircleSize, height: Dimensions.whiteCircleSize)
                    }

                    Circle()
                        .fill(Color.oAccent)
                        .frame(width: Dimensions.blueCircleSize, height: Dimensions.blueCircleSize)

                    Image("vesselButton")
                        .frame(width: Dimensions.widthImage, height: Dimensions.heightImage)
                }

                Text("Board Vessel")
                    .foregroundColor(Color.removeAction)
                    .multilineTextAlignment(.center)
                    .font(.caption1)
                    .offset(y: -Dimensions.offset)
            }
        }
        .padding(.top, -Dimensions.topPadding)
    }
}

struct BoardVesselButtonView_Previews: PreviewProvider {
    static let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }

    static var previews: some View {
        Group {
            ForEach(localizations, id: \.identifier) { locale in
                BoardVesselButtonView()
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding(.top, 68)
                    .environment(\.locale, locale)
                    .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
            }
        }
    }
}
