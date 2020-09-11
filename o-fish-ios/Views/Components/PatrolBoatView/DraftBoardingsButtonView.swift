//
//  DraftBoardingsButtonView.swift
//  
//  Created on 9/8/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DraftBoardingsButtonView: View {
    @Binding var draftBoardingsCount: Int
    var action: (() -> Void)?

    private enum Dimensions {
        static let bottomPadding: CGFloat = 5.0
        static let sizeOffset = CGSize(width: 10, height: 5)
        static let topPadding: CGFloat = 24.0
        static let boardingCountSize: CGFloat = 18.0
        static let width: CGFloat = 90.0
        static let topPaddingForEmptyDraft: CGFloat = 8.0
    }

    var body: some View {
        Button(action: action ?? {}) {

            VStack(spacing: .zero) {
                if draftBoardingsCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: Dimensions.boardingCountSize, height: Dimensions.boardingCountSize)
                        Text("\(draftBoardingsCount)")
                            .foregroundColor(.white)
                            .font(.caption1)
                    }
                        .offset(Dimensions.sizeOffset)
                        .zIndex(1)
                }

                Image(systemName: "doc.text")
                    .font(.title2)
                    .padding(.bottom, Dimensions.bottomPadding)
                Text("Draft Boardings")
                    .font(.caption1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
                .foregroundColor(Color.removeAction)
        }
        .padding(.top, draftBoardingsCount > 0 ? -Dimensions.topPadding : -Dimensions.topPaddingForEmptyDraft)
            .frame(width: Dimensions.width)
    }
}

struct DraftBoardingsButtonView_Previews: PreviewProvider {
    static let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }

    static var previews: some View {
        Group {
            ForEach(localizations, id: \.identifier) { locale in
                DraftBoardingsButtonView(draftBoardingsCount: .constant(1))
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .environment(\.locale, locale)
                    .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
            }
        }
    }
}
