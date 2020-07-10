//
//  BoardVesselButton.swift
//  
//  Created on 7/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BoardVesselButton: View {

    @ObservedObject var onDuty: DutyState
    var report = ReportViewModel()
    var onHeader = true

    @State private var showingReportRootView = false
    @State private var showingGoOnDutyAlert = false

    private enum Dimensions {
        static let mainSpacing: CGFloat = 24.0
        static let padding: CGFloat = 16.0
        static let bottomPadding: CGFloat = 45.0
    }

    private var prefilledReport: ReportViewModel {
        let startReport = ReportViewModel()
        startReport.vessel.name = report.vessel.name
        startReport.vessel.homePort = report.vessel.homePort
        startReport.vessel.permitNumber = report.vessel.permitNumber
        startReport.vessel.nationality = report.vessel.nationality
        return startReport
    }

    var body: some View {

        VStack(spacing: .zero) {
            CallToActionButton(title: "Board Vessel", action: boardVesselButtonClicked)
                .padding(.top, onHeader ? Dimensions.mainSpacing : Dimensions.padding)
                .padding(.bottom, onHeader ? Dimensions.mainSpacing : Dimensions.bottomPadding)
                .padding(.horizontal, Dimensions.padding)
                .alert(isPresented: $showingGoOnDutyAlert) {
                    Alert(title: Text("You're currently off duty"),
                          message: Text("Change status to \"On Duty\" "),
                          primaryButton: .default(Text("Yes")) {
                            self.onDuty.onDuty = true
                            self.showingReportRootView.toggle()
                        },
                          secondaryButton: .cancel())
            }

            NavigationLink(destination: ReportNavigationRootView(report: prefilledReport,
                                                                 prefilledVesselAvailable: true),
                           isActive: $showingReportRootView) {
                            EmptyView()
            }

        }
    }

    private func boardVesselButtonClicked() {
        if !onDuty.onDuty {
            showingGoOnDutyAlert.toggle()

            return
        }
        showingReportRootView.toggle()
    }
}

struct BoardVesselButton_Previews: PreviewProvider {
    static var previews: some View {
        BoardVesselButton(onDuty: .sample)
    }
}
