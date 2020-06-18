//
//  ReportNavigationRootView.swift
//
//  Created on 26/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ReportNavigationRootView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var report: ReportViewModel

    private var prefilledVesselAvailable: Bool
    @State private var showingAlertItem: AlertItem?
    @State private var notFilledScreens: [String] = TopTabBarItems.allCases.map { $0.rawValue }

    init(report: ReportViewModel? = nil, prefilledVesselAvailable: Bool = false) {
        self.report = report ?? ReportViewModel()
        self.prefilledVesselAvailable = prefilledVesselAvailable
    }

    var body: some View {
        TopTabBarContainerView(report: report,
            prefilledVesselAvailable: prefilledVesselAvailable,
            showingAlertItem: $showingAlertItem,
            showSubmitAlert: showFinalAlert,
            notFilledScreens: $notFilledScreens
        )

            .edgesIgnoringSafeArea(.bottom)
            .background(Color.backgroundGrey)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: discardReport) {
                    Text("Cancel")
                }, trailing: Button(action: submitNavBarClicked) {
                    Text("Submit")
                })
            .navigationBarTitle("New Boarding", displayMode: .inline)
            .showingAlert(alertItem: $showingAlertItem)
    }

    /// Logic

    private func showSubmitAlert() {
        showingAlertItem = AlertItem(title: "Submit boarding?",
            message: "Are you sure you want to submit the boarding?",
            primaryButton: .default(Text("Keep Editing")),
            secondaryButton: .cancel(Text("Submit"), action: saveAlertClicked))
    }

    private func showSubmitNotFilledAlert() {
        showingAlertItem = AlertItem(title: NSLocalizedString("You left the following sections blank", comment: "")
            + ":\n" + notFilledScreens.map { NSLocalizedString($0, comment: "") }.joined(separator: "\n"),

            message: "Are you sure you want to submit the boarding?",
            primaryButton: .default(Text("Keep Editing")),
            secondaryButton: .cancel(Text("Submit"), action: saveAlertClicked))
    }

    private func showFinalAlert() {
        if notFilledScreens.isEmpty {
            showSubmitAlert()
        } else {
            showSubmitNotFilledAlert()
        }
    }

    /// Actions
    private func submitNavBarClicked() {
        showFinalAlert()
    }

    private func discardReport() {
        report.discard()
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAlertClicked() {
        print("Saving report in Realm")
        report.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct ReportNavigationRootView_Previews: PreviewProvider {
    static var previews: some View {
        ReportNavigationRootView(report: ReportViewModel.sample)
            .environmentObject(Settings.shared)
    }
}
