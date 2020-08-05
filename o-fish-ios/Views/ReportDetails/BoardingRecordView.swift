//
//  BoardingRecordView.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BoardingRecordView: View {
    @ObservedObject var report: ReportViewModel
    @ObservedObject var onDuty: DutyState

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: .zero) {
            Color.inactiveBar.frame(height: 0.5)
            ScrollView {
                VStack(spacing: Dimensions.spacing) {
                    InspectionSummaryView(report: report)
                        .background(Color.white)
                        .compositingGroup()
                        .defaultShadow()

                    wrappedShadowView {
                        VesselSummaryView(vessel: report.vessel)
                    }
                    if !report.vessel.lastDelivery.isEmpty {
                        wrappedShadowView {
                            LastDeliverySummaryView(delivery: report.vessel.lastDelivery)
                        }
                    }
                    ForEach(report.vessel.ems) { ems in
                        wrappedShadowView {
                            EMSSummaryView(ems: ems)
                        }
                    }
                    if !report.captain.isEmpty {
                        wrappedShadowView {
                            CrewMemberStaticView(crewMember: report.captain,
                                isCaptain: true,
                                isEditable: false)
                        }
                    }
                    if !report.crew.isEmpty {
                        wrappedShadowView {
                            CrewSummaryView(crew: report.crew)
                        }
                    }
                    wrappedShadowView {
                        ActivitySummaryView(inspection: report.inspection)
                    }
                    if !report.inspection.actualCatch.isEmpty {
                        wrappedShadowView {
                            CatchSummaryView(catchList: report.inspection.actualCatch)
                        }
                    }
                    if !report.inspection.summary.violations.isEmpty {
                        wrappedShadowView {
                            ViolationsSummaryView(violations: report.inspection.summary.violations)
                        }
                    }
                    if !report.notes.isEmpty {
                        wrappedShadowView {
                            NotesSummaryView(notes: report.notes)
                        }
                    }
                }
            }

            BoardVesselButton(onDuty: onDuty, report: report, onHeader: false)
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.white)
                .compositingGroup()
                .bottomShadow()
        }
            .background(Color.backgroundGrey)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Boarding", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                BackButton(label: "\(report.vessel.name)")
            })
    }
}

struct BoardingRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BoardingRecordView(report: .sample, onDuty: .sample)
                .environmentObject(Settings.shared)
        }
    }
}
