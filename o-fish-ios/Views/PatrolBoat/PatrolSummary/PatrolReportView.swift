//
//  PatrolReportView.swift
//
//  Created on 10/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PatrolReportView: View {

    var report: ReportViewModel
    var showingOnSummary = false

    @State private var vesselImage: PhotoViewModel?
    private let photoQueryManager = PhotoQueryManager.shared

    private struct Dimensions {
        static let leadingSpacing: CGFloat = 4.0
        static let padding: CGFloat = 16.0
        static let heightDivider: CGFloat = 1.0
        static let circleSize: CGFloat = 12.0
        static let topPadding: CGFloat = 18.0
    }

    var body: some View {

        VStack(spacing: .zero) {
            HStack(alignment: .top, spacing: .zero) {

                if showingOnSummary {
                    Circle()
                        .fill(report.draft ? Color.spanishOrange : Color.white)
                        .frame(width: Dimensions.circleSize, height: Dimensions.circleSize)
                        .padding(.trailing, Dimensions.padding/2.0)
                        .padding(.top, Dimensions.topPadding)
                }

                VesselImageView(vesselImage: vesselImage)
                    .padding(.trailing, Dimensions.padding)

                VStack(spacing: .zero) {
                    HStack {
                        Text(report.vessel.name)
                            .foregroundColor(.oText)
                            .font(.body)
                        Spacer()
                        StatusSymbolView(risk: report.inspection.summary.safetyLevel.level)
                    }
                    VStack(spacing: Dimensions.leadingSpacing) {
                        CaptionLabel(title: (report.date as Date).justDate(), color: .gray)
                        CaptionLabel(title: (report.date as Date).justTime(), color: .gray)
                    }
                        .font(.subheadline)
                }
            }
                .padding(.bottom, Dimensions.padding)
            Divider()
                .frame(height: Dimensions.heightDivider)
        }
            .padding([.top], Dimensions.padding)
            .onAppear(perform: onAppear)
    }

    /// Actions

    private func onAppear() {
        let permitNumber = self.report.vessel.permitNumber
        self.vesselImage = photoQueryManager.lastVesselImage(permitNumber: permitNumber)
    }

}

struct PatrolReportView_Previews: PreviewProvider {
    static var previews: some View {
        let draftReport: ReportViewModel = .sample
        draftReport.draft = true
        return VStack {
            PatrolReportView(report: .sample)
            PatrolReportView(report: .sample, showingOnSummary: true)
            PatrolReportView(report: draftReport, showingOnSummary: true)
        }
    }
}
