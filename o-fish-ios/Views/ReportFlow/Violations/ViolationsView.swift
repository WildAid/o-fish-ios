//
//  ViolationsView.swift
//
//  Created on 3/12/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationsView: View {
    private let report: ReportViewModel
    private var crew: [CrewMemberViewModel]
    @ObservedObject private var summary: SummaryViewModel

    @State private var currentlyEditingViolationId: String
    @State private var showingAddViolationButton: Bool

    @Binding private var allFieldsComplete: Bool

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let topPadding: CGFloat = 8
    }

    init(report: ReportViewModel,
         crew: [CrewMemberViewModel],
         summary: SummaryViewModel,
         allFieldsComplete: Binding<Bool>) {

        if summary.violations.isEmpty {
            let violation = ViolationViewModel()
            summary.violations.append(violation)
        }

        _showingAddViolationButton = State(initialValue: !(summary.violations.last?.isEmpty ?? true))
        _currentlyEditingViolationId = State(initialValue: summary.violations.last?.id ?? "")
        _allFieldsComplete = allFieldsComplete

        self.report = report
        self.crew = crew
        self.summary = summary
    }

    var body: some View {
        KeyboardControllingScrollView {
            VStack(spacing: Dimensions.spacing) {

                ForEach(self.summary.violations.enumeratedArray(), id: \.element.id) { (index, violation) in
                    ViolationView(currentEditingViolationId: self.$currentlyEditingViolationId,
                        isViolationNonEmpty: self.$showingAddViolationButton,
                        report: self.report,
                        crew: self.crew,
                        violation: violation,
                        index: index + 1,
                        removeClicked: self.removeViolation
                    )
                }

                if self.summary.violations.isEmpty || self.showingAddViolationButton {
                    SectionButton(title: "Add Violation",
                        systemImageName: "plus",
                        action: self.addViolation)
                        .padding(.top, Dimensions.topPadding)
                        .padding(.bottom, Dimensions.spacing)
                }

                wrappedShadowView {
                    ViolationSeizureInputView(seizure: self.summary.seizures, reportId: self.report.id)
                }

                // TODO: Should be revisited after the June 2020 SwiftUI improvements
                HStack {
                    Spacer()
                }
                Spacer()
            }
        }
            .background(Color.oBackground)
            .onAppear(perform: { self.allFieldsComplete = true })
    }

    private func updateEditingViolation() {
        currentlyEditingViolationId = summary.violations.last?.id ?? ""
        showingAddViolationButton = !(summary.violations.last?.isEmpty ?? true)
    }

    /// Action Handlers
    private func removeViolation(_ violation: ViolationViewModel) {
        summary.violations.removeAll { $0.id == violation.id }
        updateEditingViolation()
    }

    private func addViolation() {
        let violation = ViolationViewModel()
        self.summary.violations.append(violation)
        updateEditingViolation()
    }
}

struct ViolationsView_Previews: PreviewProvider {
    static var previews: some View {
        ViolationsView(report: .sample, crew: [.sample, .sample], summary: .sample, allFieldsComplete: .constant(false))
    }
}
