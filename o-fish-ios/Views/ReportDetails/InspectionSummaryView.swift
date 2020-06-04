//
//  InspectionSummaryView.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct InspectionSummaryView: View {
    @ObservedObject var report: ReportViewModel

    private enum Dimensions {
        static let bottomPadding: CGFloat = 24.0
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack(alignment: .top) {
                DateTimeStackView(date: report.date)
                StatusSymbolView(risk: report.inspection.summary.safetyLevel.level, size: .large)
            }
                .padding([.horizontal], Dimensions.spacing)
            LocationDisplayView(report: report)
            if !report.inspection.attachments.notes.isEmpty || !report.inspection.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: report.inspection.attachments, isEditable: false)
                    .padding([.horizontal], Dimensions.spacing)
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct InspectionSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        InspectionSummaryView(report: .sample)
            .environmentObject(Settings.shared)
    }
}
