//
//  DutyReportsView.swift
//
//  Created on 2/06/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DutyReportsView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var dutyReports: [ReportViewModel] = []
    @ObservedObject var onDuty: DutyState

    @State private var showingBoardingRecordView = false
    @State private var selectedReport = ReportViewModel()

    private let snapshotManager = LocationSnapshotManager()

    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                wrappedShadowView {
                    VStack(spacing: .zero) {
                        ForEach(self.dutyReports) { report in

                            VesselRecordItemView(report: report,
                                snapshotManager: self.snapshotManager)
                                .onTapGesture {
                                    self.openBoardingRecordView(with: report)
                                }
                        }
                    }
                }
            }

            NavigationLink(destination: BoardingRecordView(report: selectedReport, onDuty: onDuty), isActive: $showingBoardingRecordView) {
                EmptyView()
            }
        }
            .background(Color.backgroundGrey)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Duty Reports", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                BackButton(label: "Back")
            })
    }

    /// Actions

    private func openBoardingRecordView(with report: ReportViewModel) {
        selectedReport = report
        showingBoardingRecordView = true
    }
}

struct DutyReportsView_Previews: PreviewProvider {
    static var previews: some View {
        DutyReportsView(dutyReports: [.sample, .sample, .sample],
                        onDuty: .sample)
    }
}
