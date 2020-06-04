//
//  ActivitySummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ActivitySummaryView: View {
    @ObservedObject var inspection: InspectionViewModel

    private enum Dimensions {
        static let bottomPadding: CGFloat = 24
        static let spacing: CGFloat = 16
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            TitleLabel(title: "Activity")
                .padding(.top, Dimensions.spacing)

            LabeledText(label: "Activity", text: "\(inspection.activity.name)")
            if !inspection.activity.attachments.notes.isEmpty || !inspection.activity.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: inspection.activity.attachments, isEditable: false)
            }
            Divider()

            LabeledText(label: "Fishery", text: "\(inspection.fishery.name)")
            if !inspection.fishery.attachments.notes.isEmpty || !inspection.fishery.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: inspection.fishery.attachments, isEditable: false)
            }
            Divider()

            LabeledText(label: "Gear", text: "\(inspection.gearType.name)")
            if !inspection.gearType.attachments.notes.isEmpty || !inspection.gearType.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: inspection.gearType.attachments, isEditable: false)
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct ActivitySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySummaryView(inspection: .sample)
    }
}
