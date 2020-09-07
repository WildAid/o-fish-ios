//
//  LoadingVesselRecordView.swift
//
//  Created on 4/17/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LoadingVesselRecordView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: Settings
    @ObservedObject var report: ReportViewModel
    @ObservedObject var onDuty: DutyState
    @Binding var rootIsActive: Bool
    @State private var storedReports: [ReportViewModel] = []
    @State private var loading = true

    private let spacingBackButton: CGFloat = 1.0

    var body: some View {
        VStack {
            if loading {
                LoadingIndicatorView(isAnimating: self.$loading, style: .large)
            } else {
                VesselRecordView(reports: storedReports, onDuty: onDuty, rootIsActive: $rootIsActive)
            }
        }
            .navigationBarTitle("Vessel", displayMode: .inline)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                BackButton(label: "Search")
            })
            .navigationBarBackButtonHidden(true)
            .onAppear(
                perform: loadReports
            )
    }

    private func loadReports() {
        storedReports = []
        let predicate = NSPredicate(format: "vessel.name == %@ AND vessel.permitNumber == %@", report.vessel.name, report.vessel.permitNumber)
        let realmReports = settings.realmUser?
            .agencyRealm()?
            .objects(Report.self)
            .filter(predicate)
            .sorted(byKeyPath: "timestamp", ascending: false)
        if let realmReports = realmReports {
            for report in realmReports {
                storedReports.append(ReportViewModel(report))
            }
        }
        loading = false
    }
}

struct LoadingVesselRecordView_Previews: PreviewProvider {
    static var settings = Settings()
    static var previews: some View {
        LoadingVesselRecordView(report: .sample,
                                onDuty: .sample,
                                rootIsActive: .constant(true))
        .environmentObject(settings)
    }
}
