//
//  ViolationsSummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationsSummaryView: View {
    var violations: [ViolationViewModel]

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            TitleLabel(title: NSLocalizedString("Violations", comment: "") + " (\(violations.count))")
                .padding(.top, Dimensions.spacing)

            ForEach(violations.enumeratedArray(), id: \.element.id) { (index, violation) in
                VStack(spacing: Dimensions.spacing) {
                    ViolationStaticItemView(violation: violation)

                    if self.violations.count > index + 1 { Divider() }
                }
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct ViolationsSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        var violations: [ViolationViewModel] = []
        violations.append(.sample)
        violations.append(.sample)
        violations.append(.sample)
        return ViolationsSummaryView(violations: violations)
    }
}
