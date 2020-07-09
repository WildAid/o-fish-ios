//
//  EMSSummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EMSSummaryView: View {
    @ObservedObject var ems: EMSViewModel
    var isEditable = false
    var onClickEdit: (() -> Void)?

    private enum Dimensions {
        static let bottomPading: CGFloat = 24.0
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: "Electronic Monitoring System")
                if isEditable {
                    Button(action: onClickEdit ?? {}) {
                       EditIconView()
                    }
                        .foregroundColor(.secondary)
                }
            }
                .padding(.top, Dimensions.spacing)

            HStack(alignment: .top, spacing: Dimensions.spacing) {
                LabeledText(label: "Type", text: "\(ems.emsType)")
                if ems.emsType == "Other" {
                    LabeledText(label: "Description", text: "\(ems.emsDescription)")
                }
            }

            LabeledText(label: "Registry Number", text: "\(ems.registryNumber)")

            if !ems.attachments.notes.isEmpty || !ems.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: ems.attachments, isEditable: false)
            }
        }
            .padding(.bottom, Dimensions.bottomPading)
    }
}

struct EMSSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EMSSummaryView(ems: .sample, isEditable: true)
            Divider()
            EMSSummaryView(ems: .sample, isEditable: false)
        }
    }
}
