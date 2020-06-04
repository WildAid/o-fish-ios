//
//  ViolationItemView.swift
//
//  Created on 3/12/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationStaticView: View {
    var violation: ViolationViewModel
    let index: Int

    var editClicked: ((ViolationViewModel) -> Void)?

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: NSLocalizedString("Violation", comment: "") + " \(index)")
                Button(action: { self.editClicked?(self.violation) }) {
                    EditIconView()
                }
            }
                .padding(.top, Dimensions.spacing)

            ViolationStaticItemView(violation: violation)
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct ViolationStaticView_Previews: PreviewProvider {
    static var previews: some View {
        ViolationStaticView(violation: .sample, index: 1)
    }
}
