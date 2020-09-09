//
//  LastDeliverySummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LastDeliverySummaryView: View {
    @ObservedObject var delivery: DeliveryViewModel
    var isEditable = false
    var onClickEdit: (() -> Void)?

    private enum Dimensions {
        static let bottomPading: CGFloat = 24.0
        static let padding: CGFloat = 16.0
        static let noSpacing: CGFloat = 0.0
    }

    var body: some View {
        VStack(spacing: Dimensions.padding) {
            HStack(alignment: .center) {
                TitleLabel(title: "Last Delivery")
                if isEditable {
                    Button(action: onClickEdit ?? {}) {
                       EditIconView()
                    }
                        .foregroundColor(.secondary)
                }
            }
                .padding(.top, Dimensions.padding)

            HStack(alignment: .top, spacing: Dimensions.padding) {
                LabeledText(label: "Date", text: "\(delivery.date?.justLongDate() ?? "")")
                LabeledText(label: "Business", text: "\(delivery.business)")
            }

            VStack(alignment: .leading, spacing: Dimensions.noSpacing) {
                CaptionLabel(title: "Location")
                Text(delivery.location)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !delivery.attachments.notes.isEmpty || !delivery.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: delivery.attachments, isEditable: false)
            }
        }
            .padding(.bottom, Dimensions.bottomPading)
    }
}

struct LastDeliverySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LastDeliverySummaryView(delivery: .sample, isEditable: true)
            LastDeliverySummaryView(delivery: .sample, isEditable: false)
        }
    }
}
