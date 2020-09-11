//
//  BottomPatrolView.swift
//  
//  Created on 9/8/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BottomPatrolView: View {
    @Binding var draftBoardingsCount: Int
    var findAction: (() -> Void)?
    var boardVesselAction: (() -> Void)?
    var draftBoardingsAction: (() -> Void)?

    private enum Dimensions {
        static let height: CGFloat = 83.0
        static let padding: CGFloat = 30.0
        static let topPadding: CGFloat = 6.0
    }

    var body: some View {

        HStack(alignment: .top) {
            FindRecordsButtonView(action: findAction)
                .padding(.leading, Dimensions.padding)
                .padding(.top, -Dimensions.topPadding)
            Spacer(minLength: .zero)
            BoardVesselButtonView(action: boardVesselAction)
            Spacer(minLength: .zero)
            DraftBoardingsButtonView(draftBoardingsCount: $draftBoardingsCount,
                                     action: draftBoardingsAction)
                .padding(.trailing, Dimensions.padding)

        }
        .frame(height: Dimensions.height)
        .background(Color.white)
    }
}

struct BottomPatrolView_Previews: PreviewProvider {
    static let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }

    static var previews: some View {
        Group {
            ForEach(localizations, id: \.identifier) { locale in
                BottomPatrolView(draftBoardingsCount: .constant(1))
                    .environment(\.locale, locale)
                    .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
            }
        }
    }
}
