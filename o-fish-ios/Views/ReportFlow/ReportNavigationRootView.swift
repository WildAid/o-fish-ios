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
    @Binding var rootIsActive: Bool

    private var prefilledAvailable: Bool
    @State private var showingAlertItem: AlertItem?
    @State private var notFilledScreens: [String] = TopTabBarItems.allCases.map { $0.rawValue }
    @State private var prefilledCrewAvailable: Bool

    init(report: ReportViewModel? = nil, prefilledAvailable: Bool = false, rootIsActive: Binding<Bool>) {
        self.report = report ?? ReportViewModel()
        self.prefilledAvailable = prefilledAvailable
        _rootIsActive = rootIsActive
        if let menuData = app.currentUser()?.agencyRealm()?.objects(MenuData.self).first {
            Settings.shared.menuData = menuData
        } else {
            print("Failed to read menus")
        }
        _prefilledCrewAvailable = State(initialValue: prefilledAvailable)
    }

    var body: some View {
        TopTabBarContainerView(report: report,
            prefilledAvailable: prefilledAvailable,
            prefilledCrewAvailable: $prefilledCrewAvailable,
            showingAlertItem: $showingAlertItem,
            showSubmitAlert: showFinalAlert,
            notFilledScreens: $notFilledScreens
        )

            .edgesIgnoringSafeArea(.bottom)
            .background(Color.backgroundGrey)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: showCancelAlert) {
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

    private func showCancelAlert() {
        showingAlertItem = AlertItem(title: NSLocalizedString("Cancel boarding?", comment: ""),
        message: "This boarding will not be saved.",
        primaryButton: .default(Text("Keep Editing")),
        secondaryButton: .cancel(Text("Cancel Boarding"), action: discardReport))
    }

    private func showFinalAlert() {
        if notFilledScreens.isEmpty {
            showSubmitAlert()
        } else {
            showSubmitNotFilledAlert()
        }
    }

    private func showSubmittedAlert() {
        self.showingAlertItem = AlertItem(title: "Boarding Submitted!", secondaryButton: .cancel(Text("Ok"), action: { self.rootIsActive.toggle() }))
    }

    /// Actions
    private func submitNavBarClicked() {
        showFinalAlert()
    }

    private func discardReport() {
        report.discard()
        rootIsActive.toggle()
    }

    private func saveAlertClicked() {
        if prefilledCrewAvailable {
            let captain = CrewMemberViewModel()
            captain.isCaptain = true
            report.captain = captain
            report.crew = [CrewMemberViewModel]()
        }
        report.save()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showSubmittedAlert()
        }
    }
}

struct ReportNavigationRootView_Previews: PreviewProvider {
    static var previews: some View {
        ReportNavigationRootView(report: ReportViewModel.sample,
                                 rootIsActive: .constant(true))
            .environmentObject(Settings.shared)
    }
}
