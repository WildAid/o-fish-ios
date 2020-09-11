//
//  VesselRecordItemView.swift
//
//  Created on 3/25/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselRecordItemView: View {

    @ObservedObject var report: ReportViewModel
    @State private var image = UIImage()
    @State private var isPictureLoading = true
    var snapshotManager: LocationSnapshotManager

    private var violationsTitle: String {

        var warningString = ""
        var citationString = ""
        let warnings = report.inspection.summary.violations.filter({ $0.disposition == .warning }).count
        let citations = report.inspection.summary.violations.filter({ $0.disposition == .citation }).count

        if warnings > 0 {
            let localizedWarning =  NSLocalizedString("Warning", comment: "localized Warning")
            let localizedWarnings = NSLocalizedString("Warnings", comment: "localized Warnings")
            warningString = "\(warnings) \(warnings == 1 ? localizedWarning : localizedWarnings)"
        }

        if citations > 0 {
            let localizedCitation =  NSLocalizedString("Citation", comment: "localized Citation")
            let localizedCitations = NSLocalizedString("Citations", comment: "localized Citations")
            citationString = "\(citations) \(citations == 1 ? localizedCitation : localizedCitations)"
        }

        if warningString.isEmpty && citationString.isEmpty {

            return "0 \(NSLocalizedString("Violations", comment: ""))"
        }

        return "\(warningString)\(warnings > 0 && citations > 0 ? " • " : "")\(citationString)"
    }

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 16.0
        static let imageSize: CGFloat = 64.0
        static let imageCornerRadius: CGFloat = 6.0
        static let stackSpacing: CGFloat = 2.0
        static let noSpacing: CGFloat = 0.0
    }

    var body: some View {

        DispatchQueue.main.async {
            self.snapshotManager.createImageFrom(self.report.location.location, in: Dimensions.imageSize) {
                self.isPictureLoading = false
                self.image = self.snapshotManager.picture
            }
        }

        return VStack(alignment: .leading, spacing: Dimensions.noSpacing) {
            HStack(alignment: .top, spacing: Dimensions.spacing) {
                ZStack {
                    Image(uiImage: image)
                        .frame(width: Dimensions.imageSize,
                            height: Dimensions.imageSize,
                            alignment: .center)
                        .foregroundColor(.white)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(Dimensions.imageCornerRadius)
                    ActivityIndicator(isAnimating: self.$isPictureLoading, style: .medium)
                }

                VStack(alignment: .leading, spacing: Dimensions.stackSpacing) {
                    Text(report.date.justDate())
                        .foregroundColor(.text)
                        .font(.body)

                    CaptionLabel(title: violationsTitle,
                        color: .gray,
                        font: .subheadline)
                }
                    .padding(.bottom, Dimensions.bottomPadding)
                Spacer()

                StatusSymbolView(risk: report.inspection.summary.safetyLevel.level)
            }
                .padding(.vertical, Dimensions.bottomPadding)

            Divider()
        }
    }
}

struct VesselRecordItemView_Previews: PreviewProvider {
    static var previews: some View {
        VesselRecordItemView(report: .sample,
            snapshotManager: LocationSnapshotManager())
    }
}
