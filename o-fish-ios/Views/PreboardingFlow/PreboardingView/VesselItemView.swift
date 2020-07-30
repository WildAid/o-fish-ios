//
//  VesselItemView.swift
//
//  Created on 3/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselItemView: View {

    var report: ReportViewModel

    @State private var vesselImage: PhotoViewModel?
    private let photoQueryManager = PhotoQueryManager.shared

    private struct Dimensions {
        static let leadingSpacing: CGFloat = 4.0
        static let padding: CGFloat = 16.0
        static let heightDivider: CGFloat = 1.0
    }

    var body: some View {

        VStack(spacing: .zero) {
            HStack(alignment: .top, spacing: .zero) {
                VesselImageView(vesselImage: vesselImage)
                    .padding(.trailing, Dimensions.padding)

                VStack(spacing: .zero) {
                    HStack {
                        Text(report.vessel.name)
                            .foregroundColor(.text)
                            .font(.body)
                        Spacer()
                        StatusSymbolView(risk: report.inspection.summary.safetyLevel.level)
                    }
                    VStack(spacing: Dimensions.leadingSpacing) {
                        CaptionLabel(title: NSLocalizedString("Permit #", comment: "") + report.vessel.permitNumber, color: .gray)
                        CaptionLabel(title: NSLocalizedString("Last Boarding", comment: "") + " " + (report.date as Date).justLongDate(),
                                     color: .gray)
                        CaptionLabel(title: "\(report.crew.count)" + " "
                            +  NSLocalizedString(report.crew.count > 1 ? "Crew Members" : "Crew Member", comment: ""),
                                     color: .gray)
                    }
                        .font(.subheadline)
                }
            }
                .padding(.bottom, Dimensions.padding)
            Divider()
                .frame(height: Dimensions.heightDivider)
        }
            .padding([.horizontal, .top], Dimensions.padding)
            .onAppear(perform: onAppear)
    }

    /// Actions

    private func onAppear() {
        let permitNumber = self.report.vessel.permitNumber
        self.vesselImage = photoQueryManager.lastVesselImage(permitNumber: permitNumber)
    }

}

struct VesselItemView_Previews: PreviewProvider {
    static var previews: some View {
        VesselItemView(report: .sample)
    }
}
