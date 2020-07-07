//
//  ViolationSeizureInputView.swift
//
//  Created on 14/4/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationSeizureInputView: View {
    @ObservedObject var seizure: SeizuresViewModel
    let reportId: String

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let textFrameHeight: CGFloat = 45
        static let bottomPadding: CGFloat = 24.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: "Seizure")
                AddAttachmentsButton(attachments: seizure.attachments, reportId: reportId)
            }
                .padding(.top, Dimensions.spacing)

            VStack(spacing: Dimensions.spacing) {
                CaptionLabel(title: "Description")
                InputMultilineField(text: $seizure.description)
                    .frame(minHeight: Dimensions.textFrameHeight) // TODO: fixme size from count of lines * font
            }

            AttachmentsView(attachments: seizure.attachments)
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct ViolationSeizureInputView_Previews: PreviewProvider {
    static var previews: some View {
        ViolationSeizureInputView(seizure: .sample, reportId: "testID")
    }
}
