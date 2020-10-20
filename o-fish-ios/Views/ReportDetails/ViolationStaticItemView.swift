//
//  ViolationStaticItemView.swift
//
//  Created on 5/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationStaticItemView: View {
    var violation: ViolationViewModel

    private let spacing: CGFloat = 16.0

    var body: some View {
        VStack(spacing: spacing) {
            LabeledText(label: "Violation", text: violation.fullViolationDescription)
            .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .top, spacing: spacing) {
                LabeledText(label: "Result of Violation",
                    text: NSLocalizedString(violation.disposition.rawValue, comment: "Violation result localized"))
                LabeledText(label: "Issued to",
                            text: violation.crewMember.name + titleOrEmpty)
            }
            AttachmentsView(attachments: violation.attachments, isEditable: false)
        }
    }

    var titleOrEmpty: String {
        violation.crewMember.isCaptain ? " (" + NSLocalizedString("Captain", comment: "") + ")" : ""
    }
}

struct ViolationStaticItemView_Previews: PreviewProvider {
    static var previews: some View {
        ViolationStaticItemView(violation: .sample)
    }
}
