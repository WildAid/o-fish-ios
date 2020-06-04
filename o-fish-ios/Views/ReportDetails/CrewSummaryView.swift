//
//  CrewSummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CrewSummaryView: View {
    var crew: [CrewMemberViewModel]

    private enum Dimensions {
        static let noSpacing: CGFloat = 0.0
        static let padding: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {
            TitleLabel(title: NSLocalizedString("Crew", comment: "") + " (\(crew.count))")
                .padding(.vertical, Dimensions.padding)

            ForEach(crew.indices, id: \.self) { index in
                VStack(spacing: Dimensions.noSpacing) {
                    CrewItemView(crewMember: self.crew[index])
                        .padding(.vertical, Dimensions.padding)
                    if self.crew.count > index + 1 { Divider() }
                }
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct CrewSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        var crew: [CrewMemberViewModel] = []
        crew.append(.sample)
        crew.append(.sample)
        crew.append(.sample)
        return CrewSummaryView(crew: crew)
    }
}
