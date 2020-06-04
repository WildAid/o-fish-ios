//
//  ReportSummaryView.swift
//
//  Created on 25/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ReportSummaryView: View {
    var report: ReportViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CaptionLabel(title: report.id)

            HStack(alignment: .center, spacing: 8) {
                Text("Vessel: " + report.vessel.name)
                Text("Date: " + Date.getPrintStringFromDate(report.date))
            }
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ReportSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ReportSummaryView(report: .sample)
    }
}
