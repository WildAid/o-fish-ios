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
    @State private var showingActionSheetItem: ActionSheetItem?

    init(report: ReportViewModel? = nil, prefilledAvailable: Bool = false, rootIsActive: Binding<Bool>) {
        self.report = report ?? ReportViewModel()
        self.prefilledAvailable = prefilledAvailable
        _rootIsActive = rootIsActive
        if let menuData = app.currentUser()?.agencyRealm()?.objects(MenuData.self).first {
            Settings.shared.menuData = menuData
        } else {
            print("Failed to read menus")
        }
        _prefilledCrewAvailable = State(initialValue: !(report?.crew.isEmpty ?? true) || !(report?.captain.isEmpty ?? true))
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
                    Text("Save")
                })
            .navigationBarTitle(report.draft ? "Draft Boarding" : "New Boarding", displayMode: .inline)
            .showingAlert(alertItem: $showingAlertItem)
            .showingActionSheet(actionSheetItem: $showingActionSheetItem)
    }

    /// Logic

    private func showSubmitAlert() {
        showingActionSheetItem = ActionSheetItem(title: "Submit boarding?",
                                                 message: "Are you sure you want to submit the boarding?",
                                                 firstButton: .default(Text("Submit"), action: { self.submitAlertClicked() }),
                                                 secondButton: .default(Text("Keep Editing")),
                                                 thirdButton: .default(Text("Save and Finish Later"),
                                                                       action: { self.saveAlertClicked() }))
    }

    private func showSubmitNotFilledAlert() {
        showingActionSheetItem = ActionSheetItem(title: NSLocalizedString("You left the following sections blank", comment: "")
            + ":\n" + notFilledScreens.map { NSLocalizedString($0, comment: "") }.joined(separator: "\n"),
                                                 message: "Are you sure you want to submit the boarding?",
                                                 firstButton: .default(Text("Keep Editing")),
                                                 secondButton: .default(Text("Save and Finish Later"),
                                                                        action: { self.saveAlertClicked() }),
                                                 thirdButton: .default(Text("Submit"),
                                                                       action: { self.submitAlertClicked() }))
    }

    private func showCancelAlert() {
        showingActionSheetItem = ActionSheetItem(title: NSLocalizedString("Cancel boarding?", comment: ""),
        message: "If canceled, this boarding will not be saved. You may however save it to finish later.",
        firstButton: .default(Text("Keep Editing")),
        secondButton: .default(Text("Save and Finish Later"), action: { self.saveAlertClicked() }),
        thirdButton: .destructive(Text(report.draft ? "Delete Boarding" : "Cancel Boarding" ), action: discardReport))
    }

    private func showFinalAlert() {
        if notFilledScreens.isEmpty {
            showSubmitAlert()
        } else {
            showSubmitNotFilledAlert()
        }
    }

    private func showSubmittedAlert(isDraft: Bool) {
        self.showingAlertItem = AlertItem(title: isDraft ? "Boarding Saved!" : "Boarding Submitted!",
                                          secondaryButton: .cancel(Text("Ok"),
                                                                   action: { self.rootIsActive.toggle() }))
    }

    private func showCanceledAlert(isDraft: Bool) {
           self.showingAlertItem = AlertItem(title: isDraft ? "Boarding Deleted!" : "Boarding Canceled!",
                                             secondaryButton: .cancel(Text("Ok"),
                                                                      action: { self.rootIsActive.toggle() }))
       }

    /// Actions
    private func submitNavBarClicked() {
        showFinalAlert()
    }

    private func discardReport() {
        let isDraft = report.draft
        report.discard()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showCanceledAlert(isDraft: isDraft)
        }
    }

    private func saveAlertClicked() {
        report.draft = true
        report.save()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showSubmittedAlert(isDraft: true)
        }
    }

    private func submitAlertClicked() {
        let wasDraft = report.draft
        report.draft = false
        if prefilledCrewAvailable {
            let captain = CrewMemberViewModel()
            captain.isCaptain = true
            report.captain = captain
            report.crew = [CrewMemberViewModel]()
        }
        report.save()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showSubmittedAlert(isDraft: wasDraft)
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
