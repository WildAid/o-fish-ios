//
//  ReportSummary.swift
//
//  Created on 25/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ReportSummary: View {
    var report: ReportViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(report.id)
                .font(.caption)
                .foregroundColor(.gray)
            HStack(alignment: .center) {
                Text(report.vessel.name)
                Text(":")
                Text(Date.getPrintStringFromDate(report.date))
                .font(.caption)
                .foregroundColor(.gray)
            }

        }
    }
}

struct ReportSummary_Previews: PreviewProvider {
    static var previews: some View {
        ReportSummary(report: .sample)
    }
}
