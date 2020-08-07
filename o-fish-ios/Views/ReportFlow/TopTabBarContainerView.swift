//
//  TopTabBarNavigationView.swift
//
//  Created on 26/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

enum TopTabBarItems: String {
    case basicInformation = "Basic information"
    case vessel = "Vessel"
    case crew = "Crew"
    case activity = "Activity"
    case whatsOnBoard = "Catch"
    case violations = "Violations"
    case risk = "Risk"
    case notes = "Notes"

    static let allCases: [TopTabBarItems] = [
        .basicInformation,
        .vessel,
        .crew,
        .activity,
        .whatsOnBoard,
        .violations,
        .risk,
        .notes
    ]
}

// TODO fixme refactor in a reusable way
struct TopTabBarContainerView: View {
    @ObservedObject private var report: ReportViewModel
    @State private var prefilledVesselAvailable: Bool

    @Binding private var showingAlertItem: AlertItem?
    private var showSubmitAlert: (() -> Void)?
    @Binding private var notFilledScreens: [String]

    @State private var tabBarItems: [TabBarItem]
    @State private var selectedItem: TabBarItem

    @State private var mainButtonTitle: String
    @State private var showingNotCompleteState: Bool

    var warningColor = Color.spanishOrange

    private enum Dimensions {
        static let noSpacing: CGFloat = 0.0
        static let buttonTopPadding: CGFloat = 16.0
        static let buttonBottomPadding: CGFloat = 45.0
        static let buttonLeadingTrailingPadding: CGFloat = 16.0
    }

    init(report: ReportViewModel,
         prefilledVesselAvailable: Bool,
         showingAlertItem: Binding<AlertItem?>,
         showSubmitAlert: (() -> Void)? = nil,
         notFilledScreens: Binding<[String]>) {

        self.report = report
        self._prefilledVesselAvailable = State(initialValue: prefilledVesselAvailable)
        self._showingAlertItem = showingAlertItem
        self.showSubmitAlert = showSubmitAlert
        self._notFilledScreens = notFilledScreens

        let basicInfoItem = TabBarItem(title: TopTabBarItems.basicInformation.rawValue)
        let vesselItem = TabBarItem(title: TopTabBarItems.vessel.rawValue)
        let catchItem = TabBarItem(title: TopTabBarItems.whatsOnBoard.rawValue)
        let activityItem = TabBarItem(title: TopTabBarItems.activity.rawValue)
        let riskItem = TabBarItem(title: TopTabBarItems.risk.rawValue)
        let crewItem = TabBarItem(title: TopTabBarItems.crew.rawValue)
        let violationsItem = TabBarItem(title: TopTabBarItems.violations.rawValue)
        let notesItem = TabBarItem(title: TopTabBarItems.notes.rawValue)

        let tabItems = [
            basicInfoItem,
            vesselItem,
            crewItem,
            activityItem,
            catchItem,
            violationsItem,
            riskItem,
            notesItem
        ]

        assert(!tabItems.isEmpty, "Tab items count should be at least one")

        self._tabBarItems = State(initialValue: tabItems)
        self._selectedItem = State(initialValue: tabItems.first!)

        self._mainButtonTitle = State(initialValue: tabItems.first!.title)
        self._showingNotCompleteState = State(initialValue: false)
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {
            Color.inactiveBar.frame(height: 0.5)

            ScrollableTabBar(items: $tabBarItems,
                selectedItem: self.selectedItem,
                itemClicked: scrollableBarItemClicked)
                .background(Color.white)

            if self.isBasicInformationSelected {
                BasicInfoView(report: self.report, allFieldsComplete: allFieldsCompleteBinding)

            } else if self.isVesselSelected {
                VesselView(
                    vessel: report.vessel,
                    reportId: report.id,
                    prefilledVesselAvailable: $prefilledVesselAvailable,
                    allFieldsComplete: allFieldsCompleteBinding,
                    showingWarningState: $showingNotCompleteState)

            } else if self.isWhatsOnBoardSelected {
                CatchView(
                    inspection: report.inspection,
                    reportId: report.id,
                    allFieldsComplete: allFieldsCompleteBinding,
                    showingWarningState: $showingNotCompleteState)

            } else if self.isActivitySelected {
                ActivityView(
                    inspection: report.inspection,
                    reportId: report.id,
                    allFieldsComplete: allFieldsCompleteBinding,
                    showingWarningState: $showingNotCompleteState)

            } else if self.isRiskSelected {
                RiskView(report: self.report,
                    allFieldsComplete: allFieldsCompleteBinding)

            } else if self.isCrewSelected {
                CrewView(report: self.report,
                    allFieldsComplete: allFieldsCompleteBinding,
                    showingWarningState: $showingNotCompleteState)

            } else if self.isViolationsSelected {
                ViolationsView(report: self.report,
                    crew: ([report.captain] + report.crew).filter { !$0.isEmpty },
                    summary: report.inspection.summary,
                    allFieldsComplete: allFieldsCompleteBinding)

            } else if self.isNotesSelected {
                NotesView(report: self.report,
                    allFieldsComplete: allFieldsCompleteBinding)

            } else {
                Spacer()
            }

            VStack(spacing: Dimensions.buttonTopPadding) {
                if showingNotCompleteState {
                    Text("Continue with empty fields?")
                        .font(Font.body.weight(.semibold))
                        .foregroundColor(warningColor)
                        .padding(.top, Dimensions.buttonTopPadding)
                }

                CallToActionButton(title: self.mainButtonTitle,
                    showingArrow: self.selectedItem != tabBarItems.last,
                    action: self.mainActionButtonClicked)
                    .padding(.top, showingNotCompleteState ? 0 : Dimensions.buttonTopPadding)
                    .padding(.bottom, Dimensions.buttonBottomPadding)
                    .padding(.horizontal, Dimensions.buttonLeadingTrailingPadding)
            }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.white)
                .compositingGroup()
                .bottomShadow()
        }
            .background(Color.backgroundGrey)
            .showingAlert(alertItem: $showingAlertItem)
    }

    private var allFieldsCompleteBinding: Binding<Bool> {
        Binding<Bool>(get: {
            self.selectedItem.state == .complete
        }, set: {
            self.selectedItem.state = $0 ? .complete : .started

            if $0 {
                self.updateNotCompletedItems()
                self.showingNotCompleteState = false
                self.updateMainButtonTitle()
            }
        })
    }

    private var isBasicInformationSelected: Bool {
        selectedItem.title == TopTabBarItems.basicInformation.rawValue
    }

    private var isVesselSelected: Bool {
        selectedItem.title == TopTabBarItems.vessel.rawValue
    }

    private var isWhatsOnBoardSelected: Bool {
        selectedItem.title == TopTabBarItems.whatsOnBoard.rawValue
    }

    private var isRiskSelected: Bool {
        selectedItem.title == TopTabBarItems.risk.rawValue
    }

    private var isActivitySelected: Bool {
        selectedItem.title == TopTabBarItems.activity.rawValue
    }

    private var isCrewSelected: Bool {
        selectedItem.title == TopTabBarItems.crew.rawValue
    }

    private var isViolationsSelected: Bool {
        selectedItem.title == TopTabBarItems.violations.rawValue
    }

    private var isNotesSelected: Bool {
        selectedItem.title == TopTabBarItems.notes.rawValue
    }

    /// Actions

    private func scrollableBarItemClicked(_ item: TabBarItem) {
        updateNotCompletedItems()

        if showingNotCompleteState {
            showingNotCompleteState = false
        }

        let tapBarItemsToSkip = itemsSkipping(to: item.title)

        if !tapBarItemsToSkip.isEmpty {
            showSkippingAlert(tapBarItemsToSkip.map { $0.title },
                skipClicked: { self.skipAlertClicked(nextSelectedItem: item, itemsToSkip: tapBarItemsToSkip) })
        } else {
            updateSelectedItemAndMainButtonTitle(item)
        }
    }

    private func mainActionButtonClicked() {
        updateNotCompletedItems()

        if showingNotCompleteState {
            showingNotCompleteState = false
            skipCurrent()
            switchToNextItem()
            return
        }

        if selectedItem == self.tabBarItems.last {
            showSubmitAlert?()
            return
        }

        if selectedItem.state != .complete {
            showNotCompleteState()
            return
        }

        switchToNextItem()
    }

    private func skipAlertClicked(nextSelectedItem: TabBarItem, itemsToSkip: [TabBarItem]) {
        for item in itemsToSkip {
            item.state = .skipped
        }
        updateSelectedItemAndMainButtonTitle(nextSelectedItem)
    }

    /// Logic

    private func itemsSkipping(to title: String) -> [TabBarItem] {
        var result = [TabBarItem]()
        for item in self.tabBarItems {
            if item.title != title {
                if item.state == .notStarted {
                    result.append(item)
                }
            } else {
                break
            }
        }
        return result
    }

    private func updateNotCompletedItems() {
        let notCompleted = tabBarItems.filter { $0.state != .complete }
        self.notFilledScreens = notCompleted.map { $0.title }
    }

    private func skipCurrent() {
        self.selectedItem.state = .skipped
    }

    private func switchToNextItem() {
        if let index = tabBarItems.firstIndex(of: selectedItem),
           index < tabBarItems.count - 1 {

            let nextItem = tabBarItems[index + 1]
            updateSelectedItemAndMainButtonTitle(nextItem)
        }
    }

    private func updateSelectedItemAndMainButtonTitle(_ newSelectedItem: TabBarItem) {
        selectedItem = newSelectedItem
        updateMainButtonTitle()
    }

    private func updateMainButtonTitle() {
        var title = "Submit"

        if let index = tabBarItems.firstIndex(of: selectedItem),
           index < tabBarItems.count - 1 {
            let nextItem = tabBarItems[index + 1]
            title = nextItem.title
        }
        mainButtonTitle = NSLocalizedString(title, comment: "CTA button title")
    }

    private func showNotCompleteState() {
        if let index = tabBarItems.firstIndex(of: selectedItem),
           index < tabBarItems.count - 1 {
            let nextItem = tabBarItems[index + 1]
            mainButtonTitle = NSLocalizedString("Continue to", comment: "") + " " +  NSLocalizedString(nextItem.title, comment: "")
            showingNotCompleteState = true
        }
    }

    private func showSkippingAlert(_ itemsToSkip: [String], skipClicked: @escaping () -> Void) {
        self.showingAlertItem = AlertItem(title: "Skip the following sections?",
            message: itemsToSkip.map { NSLocalizedString($0, comment: "") }.joined(separator: "\n"),
            primaryButton: .cancel(Text("Skip"), action: skipClicked)
        )
    }
}

struct TopTabBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TopTabBarContainerView(report: .sample,
            prefilledVesselAvailable: true,
            showingAlertItem: .constant(nil),
            notFilledScreens: .constant([])
        )
            .environmentObject(Settings.shared)
    }
}
