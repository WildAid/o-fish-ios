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
                    StartStopDatePicker(title: "Time On Duty",
                        startDate: $startDuty.date,
                        endDate: $plannedOffDutyTime)
                }

                wrappedShadowView {
                    VStack(spacing: .zero) {

                        TitleLabel(title: "\(self.dutyReports.count) Boardings")
                            .padding(.top, Dimensions.spacing)
                            .padding(.bottom, self.dutyReports.count > 0 ? (Dimensions.spacing / 2.0) : Dimensions.spacing)

                        ForEach(self.dutyReports) { report in

                            Button(action: { self.vesselItemClicked(report) }) {

                                PatrolReportView(report: report)
                                    .padding(.bottom, report == self.dutyReports.last ? Dimensions.bottomPadding : 0)
                            }
                        }
                    }
                }
            }

            VStack(spacing: .zero) {
                CallToActionButton(title: "Go Off Duty",
                    action: self.goOffDutyClicked)
                    .padding(.top, Dimensions.buttonTopPadding)
                    .padding(.bottom, Dimensions.buttonBottomPadding)
                    .padding(.horizontal, Dimensions.buttonLeadingTrailingPadding)
            }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.white)
                .compositingGroup()
                .bottomShadow()

            NavigationLink(destination: BoardingRecordView(report: selectedReport, onDuty: onDuty), isActive: $showingBoardingRecordView) {
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
                Text("Go Off Duty")
            })
    }

    /// Actions

    private func vesselItemClicked(_ report: ReportViewModel) {
        selectedReport = report
        showingBoardingRecordView = true
    }

    private func goOffDutyClicked() {
        startDuty.save()
        onDuty.recordOnDutyChange(status: false, date: plannedOffDutyTime)

        self.presentationMode.wrappedValue.dismiss()
    }
}

struct PatrolSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PatrolSummaryView(dutyReports: [.sample, .sample, .sample],
            startDuty: .sample,
            onDuty: .sample,
            plannedOffDutyTime: Date())
    }
}
