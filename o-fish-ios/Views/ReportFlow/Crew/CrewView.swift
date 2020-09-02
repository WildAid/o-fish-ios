//
//  CrewView.swift
//
//  Created on 3/10/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CrewView: View {
    @ObservedObject var report: ReportViewModel
    @Binding private var showingPrefilledAlert: Bool

    @Binding private var allFieldsComplete: Bool
    @Binding private var showingWarningState: Bool

    @State private var crewMemberWaitingRemoveConfirmation: CrewMemberViewModel?
    @State private var showingRemoveConfirmationAlert: Bool
    @State private var initialCaptain = CrewMemberViewModel()
    @State private var initialCrew = [CrewMemberViewModel]()

    @State private var currentEditingCrewMemberId: String
    @State private var isCurrentEditingCrewNonEmpty: Bool

    @State private var crewMembersComplete: [String: Bool]

    private enum Dimensions {
        static let topPadding: CGFloat = 8.0
        static let spacing: CGFloat = 16.0
    }

    init(report: ReportViewModel,
         prefilledCrewAvailable: Binding<Bool>,
         allFieldsComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>) {

        self.report = report

        _showingPrefilledAlert = prefilledCrewAvailable
        _currentEditingCrewMemberId = report.crew.filter({ $0.isEmpty }).count != 0 ?
            State(initialValue: report.crew.filter({ $0.isEmpty }).first?.id ?? "") :
            State(initialValue: report.captain.id)
        _isCurrentEditingCrewNonEmpty = State(initialValue: !report.captain.isEmpty)
        _showingRemoveConfirmationAlert = State(initialValue: false)

        _allFieldsComplete = allFieldsComplete
        _showingWarningState = showingWarningState

        _crewMembersComplete = State(initialValue: [:])
    }

    var body: some View {
        KeyboardControllingScrollView {
            VStack(spacing: Dimensions.spacing) {
                ForEach(self.allCrew.enumeratedArray(), id: \.element.id) { (index, member) in
                    CrewMemberView(currentEditingCrewMemberId: self.$currentEditingCrewMemberId,
                        isCrewMemberNonEmpty: self.$isCurrentEditingCrewNonEmpty,
                        informationComplete: self.informationCompleteBinding(member),
                        showingWarningState: self.$showingWarningState,
                        crewMember: member,
                        reportId: self.report.id,
                        index: index + 1,
                        editClicked: self.editItemClicked,
                        removeClicked: self.removeItemClicked
                    )
                }

                if !(self.report.crew.last?.isEmpty ?? true)
                       || self.report.crew.isEmpty
                       || (self.isCurrentEditingCrewNonEmpty && self.report.crew.last?.id == self.currentEditingCrewMemberId) {

                    SectionButton(title: "Add Crew Member", systemImageName: "plus") {
                        self.addCrewMemberClicked()
                    }
                        .padding(.top, Dimensions.topPadding)
                        .padding(.bottom, Dimensions.topPadding + Dimensions.spacing)
                }

                // TODO: Should be revisited after the June 2020 SwiftUI improvements
                HStack {
                    Spacer()
                }
                Spacer()
                    .alert(isPresented: self.$showingRemoveConfirmationAlert) {
                        Alert(title: Text("This crew member contained in violation(s)"),
                            message: Text("Are you sure you want to remove this crew member?"),
                            primaryButton: .cancel(Text("Yes"), action: self.removeCrewMemberFromViolationsClicked),
                            secondaryButton: .default(Text("Continue editing")))
                    }
            }
            .alert(isPresented: self.$showingPrefilledAlert) {
                Alert(title: Text("Prefill Crew Information From Previous Boarding?"),
                    message: Text("You'll still be able to edit fields"),
                    primaryButton: .default(Text("No")) {
                        self.showingPrefilledAlert = false
                    },
                    secondaryButton: .default(Text("Prefill"), action: self.prefillCrewClicked)
                )
            }
        }
            .onAppear(perform: self.onAppear)
    }

    private func informationCompleteBinding(_ member: CrewMemberViewModel) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.crewMembersComplete[member.id] ?? false },
            set: {
                self.crewMembersComplete[member.id] = $0
                self.checkAllInput()
            }
        )
    }

    private var allCrew: [CrewMemberViewModel] {
        [report.captain] + report.crew
    }

    /// Actions

    private func onAppear() {
        if showingPrefilledAlert {

            initialCaptain = report.captain
            initialCaptain.isCaptain = true

            for member in report.crew {
                initialCrew.append(member)
            }

            let emptyCaptain = CrewMemberViewModel()
            emptyCaptain.isCaptain = true
            report.captain = emptyCaptain
            currentEditingCrewMemberId = report.captain.id
            report.crew = [CrewMemberViewModel]()
        }
        if report.crew.isEmpty {
            let model = CrewMemberViewModel()
            report.crew.append(model)
        }
        checkingForComplete()
        checkAllInput()
    }

    private func checkingForComplete() {
        crewMembersComplete.removeAll()
        for member in report.crew {
            crewMembersComplete[member.id] = member.isComplete
        }
    }

    private func removeCrewMemberFromViolationsClicked() {
        guard let member = crewMemberWaitingRemoveConfirmation else { return }

        report.removeCrewMemberFromLinkedViolations(member)
        crewMemberWaitingRemoveConfirmation = nil

        removeCrewMemberFromCrewMemberList(member)
    }

    private func addCrewMemberClicked() {
        let newMember = CrewMemberViewModel()
        report.crew.append(newMember)
        crewMembersComplete[newMember.id] = false

        updateCurrentCrewMemberStatus(newMember)
    }

    private func editItemClicked(_ crewViewModel: CrewMemberViewModel) {
        updateCurrentCrewMemberStatus(crewViewModel)
    }

    private func removeItemClicked(_ crewViewModel: CrewMemberViewModel) {
        let violationsWithThisCrew = report.inspection.summary
            .violations.filter { $0.crewMember.id == crewViewModel.id }

        crewMembersComplete.removeValue(forKey: crewViewModel.id)

        if !violationsWithThisCrew.isEmpty {
            self.showingRemoveConfirmationAlert = true
            self.crewMemberWaitingRemoveConfirmation = crewViewModel
            return
        }

        removeCrewMemberFromCrewMemberList(crewViewModel)
    }

    private func prefillCrewClicked() {
        report.captain = initialCaptain
        report.crew = initialCrew
        currentEditingCrewMemberId = report.crew.last?.id ?? ""
        checkingForComplete()
        checkAllInput()
    }

    /// Logic

    private func checkAllInput() {
        allFieldsComplete = crewMembersComplete.values.filter { $0 == false }.isEmpty
    }

    private func updateCurrentCrewMemberStatus(_ crewMember: CrewMemberViewModel?) {
        currentEditingCrewMemberId = crewMember?.id ?? ""
        isCurrentEditingCrewNonEmpty = !(crewMember?.isEmpty ?? true)
        checkAllInput()
    }

    private func removeCrewMemberFromCrewMemberList(_ crewViewModel: CrewMemberViewModel) {
        report.crew.removeAll { $0.id == crewViewModel.id }
        updateCurrentCrewMemberStatus(report.crew.last)
    }
}

struct CrewView_Previews: PreviewProvider {
    static var previews: some View {
        CrewView(report: .sample,
            prefilledCrewAvailable: .constant(false),
            allFieldsComplete: .constant(false),
            showingWarningState: .constant(false))
    }
}
