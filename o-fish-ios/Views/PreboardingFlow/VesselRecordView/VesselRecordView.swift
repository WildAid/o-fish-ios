//
//  VesselRecordView.swift
//
//  Created on 3/25/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselRecordView: View {

    @State var reports: [ReportViewModel]
    @ObservedObject var onDuty: DutyState
    @State private var showingBoardingRecordView = false
    @State private var selectedReport = ReportViewModel()
    @State private var stillLoading = true

    private let snapshotManager = LocationSnapshotManager()

    private enum Dimensions {
        static let spacing: CGFloat = 24.0
        static let titleFontSize: CGFloat = 20.0
        static let spacingBackButton: CGFloat = 1.0
        static let topPadding: CGFloat = 16.0
        static let bottomPadding: CGFloat = 5.0
        static let noSpacing: CGFloat = 0.0
    }

    private var numberOfBoardings: Int {
        reports.count
    }

    private var numberOfWarnings: Int {
        var numberOfWarnings = 0
        for report in reports {
            numberOfWarnings += report.inspection.summary.violations.filter({ $0.disposition == .warning }).count
        }

        return numberOfWarnings
    }

    private var numberOfCitations: Int {
        var numberOfCitations = 0
        for report in reports {
            numberOfCitations += report.inspection.summary.violations.filter({ $0.disposition == .citation }).count
        }

        return numberOfCitations
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Dimensions.spacing) {
                VesselRecordHeaderView(report: reports.first ?? ReportViewModel(),
                    onDuty: onDuty,
                    boardings: numberOfBoardings,
                    warnings: numberOfWarnings,
                    citations: numberOfCitations)
                    .background(Color.white)
                    .compositingGroup()
                    .defaultShadow()

                wrappedShadowView {

                    VStack(alignment: .leading, spacing: Dimensions.noSpacing) {
                        Text("Previous Boardings")
                            .font(.system(size: Dimensions.titleFontSize))
                            .bold()
                            .padding(.top, Dimensions.topPadding)
                            .padding(.bottom, Dimensions.bottomPadding)
                        VStack(spacing: Dimensions.noSpacing) {
                            ForEach(self.reports) { report in
                                VesselRecordItemView(report: report,
                                    snapshotManager: self.snapshotManager)
                                    .onTapGesture {
                                        //TODO Need to replace on Button. For now it's unexpected behavior with showing mapViewImage.
                                        self.openBoardingRecordView(with: report)
                                    }
                            }
                        }
                    }
                }
            }

            //TODO Need to replace to ForEach. For now it's unexpected behavior with showing mapViewImage.
            NavigationLink(destination: BoardingRecordView(report: selectedReport, onDuty: onDuty), isActive: $showingBoardingRecordView) {
                EmptyView()
            }
        }
            .background(Color.backgroundGrey)
            .edgesIgnoringSafeArea(.bottom)
    }

    private func openBoardingRecordView(with report: ReportViewModel) {
        //TODO Need to replace to ForEach. For now it's unexpected behavior with showing mapViewImage.
        selectedReport = report
        showingBoardingRecordView.toggle()
    }
}

struct VesselRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VesselRecordView(reports: [.sample, .sample, .sample],
                onDuty: .sample)
        }
    }
}
