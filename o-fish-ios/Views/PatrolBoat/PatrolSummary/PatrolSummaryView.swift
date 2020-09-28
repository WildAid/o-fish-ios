//
//  PatrolSummaryView.swift
//
//  Created on 2/06/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PatrolSummaryView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var dutyReports: [ReportViewModel] = []
    @ObservedObject var startDuty: DutyChangeViewModel
    @ObservedObject var onDuty: DutyState
    @State var plannedOffDutyTime: Date
    @Binding var rootIsActive: Bool

    @State private var showingBoardingRecordView = false
    @State private var selectedReport = ReportViewModel()

    private let snapshotManager = LocationSnapshotManager()

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let bottomPadding: CGFloat = 24.0
        static let buttonTopPadding: CGFloat = 16.0
        static let buttonBottomPadding: CGFloat = 45.0
        static let buttonLeadingTrailingPadding: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                wrappedShadowView {
                    StartStopDatePicker(title: "Time At Sea",
                        startDate: $startDuty.date,
                        endDate: $plannedOffDutyTime)
                }

                VStack(spacing: .zero) {
                    HStack {
                        TitleLabel(title: titleLabel)
                        Spacer()
                        Text(draftLabel)
                            .font(.body).fontWeight(.semibold)
                            .foregroundColor(Color.spanishOrange)
                    }
                    .padding(.top, Dimensions.spacing)
                    .padding(.bottom, self.dutyReports.count > 0 ? (Dimensions.spacing / 2.0) : Dimensions.spacing)
                    .padding(.leading, Dimensions.spacing / 2.0)

                    ForEach(self.dutyReports) { report in

                        Button(action: { self.vesselItemClicked(report) }) {

                            PatrolReportView(report: report, showingOnSummary: true)
                                .padding(.bottom, report == self.dutyReports.last ? Dimensions.bottomPadding : 0)
                        }
                    }
                }
                    .padding(.trailing, Dimensions.spacing)
                    .padding(.leading, Dimensions.spacing / 2.0)
                    .background(Color.white)
                    .compositingGroup()
                    .defaultShadow()
            }

            VStack(spacing: .zero) {
                CallToActionButton(title: "Continue",
                    action: self.goOffDutyClicked)
                    .padding(.top, Dimensions.buttonTopPadding)
                    .padding(.bottom, Dimensions.buttonBottomPadding)
                    .padding(.horizontal, Dimensions.buttonLeadingTrailingPadding)
            }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.white)
                .compositingGroup()
                .bottomShadow()

            NavigationLink(destination: BoardingRecordView(report: selectedReport,
                                                           onDuty: onDuty,
                                                           rootIsActive: $rootIsActive,
                                                           showingBoardingButton: false),
                           isActive: $showingBoardingRecordView) {
                EmptyView()
            }
        }
            .background(Color.backgroundGrey)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Patrol Summary", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Cancel")
            }, trailing: Button(action: self.goOffDutyClicked) {
                Text("Continue")
            })
    }

    private var titleLabel: String {
        let boardingCount = dutyReports.count
        let boardingsString = NSLocalizedString((boardingCount == 1 ? "Boarding" : "Boardings"), comment: "")
        return "\(boardingCount) \(boardingsString)"
    }

    private var draftLabel: String {
        let draftCount = dutyReports.filter({ $0.draft }).count
        let draftString = NSLocalizedString((draftCount == 1 ? "Draft" : "Drafts"), comment: "")
        return "\(draftCount) \(draftString)"
    }

    /// Actions

    private func vesselItemClicked(_ report: ReportViewModel) {
        selectedReport = report
        showingBoardingRecordView = true
    }

    private func goOffDutyClicked() {
        startDuty.save(existingObject: true)
        onDuty.recordOnDutyChange(status: false, date: plannedOffDutyTime)

        self.presentationMode.wrappedValue.dismiss()
    }
}

struct PatrolSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PatrolSummaryView(dutyReports: [.sample, .sample, .sample],
            startDuty: .sample,
            onDuty: .sample,
            plannedOffDutyTime: Date(),
            rootIsActive: .constant(true))
    }
}
