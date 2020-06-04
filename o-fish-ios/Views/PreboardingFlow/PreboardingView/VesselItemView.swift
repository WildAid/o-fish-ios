//
//  VesselItemView.swift
//
//  Created on 3/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselItemView: View {

    var report: ReportViewModel

    private struct Dimensions {
        static let noSpacing: CGFloat = 0.0
        static let leadingSpacing: CGFloat = 4.0
        static let imageSize: CGFloat = 64.0
        static let padding: CGFloat = 16.0
        static let heightDivider: CGFloat = 1.0
    }

    var body: some View {

        VStack(spacing: Dimensions.noSpacing) {
            HStack(alignment: .top, spacing: Dimensions.noSpacing) {
                VesselIconView() //TODO Need to add real image of the vessel.
                    .padding(.trailing, Dimensions.padding)
                VStack(spacing: Dimensions.noSpacing) {
                    HStack {
                        Text(report.vessel.name)
                            .foregroundColor(.text)
                        Spacer()
                        StatusSymbolView(risk: report.inspection.summary.safetyLevel.level)
                    }
                    VStack(spacing: Dimensions.leadingSpacing) {
                        CaptionLabel(title: NSLocalizedString("Permit #", comment: "") + report.vessel.permitNumber, color: .gray)
                        CaptionLabel(title: NSLocalizedString("Last Boarding", comment: "") + " " + (report.date as Date).justLongDate(),
                                     color: .gray)
                        CaptionLabel(title: "\(report.crew.count + 1)" + " " +  NSLocalizedString("Crew Members", comment: ""),
                                     color: .gray)
                    }
                }
            }
                .padding(.bottom, Dimensions.padding)
            Divider()
                .frame(height: Dimensions.heightDivider)
        }
            .padding([.horizontal, .top], Dimensions.padding)
    }
}

struct VesselItemView_Previews: PreviewProvider {
    static var previews: some View {
        VesselItemView(report: .sample)
    }
}
