//
//  CrewMemberInputView.swift
//
//  Created on 3/10/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CrewMemberInputView: View {
    @Binding private var isCrewMemberNonEmpty: Bool
    @Binding private var informationComplete: Bool
    @Binding private var showingWarningState: Bool

    @ObservedObject private var crewMember: CrewMemberViewModel
    let reportId: String

    private var index: Int = 0
    private var isCaptain: Bool = false

    private var removeClicked: ((CrewMemberViewModel) -> Void)?

    @Binding private var showingNameWarning: Bool
    @Binding private var showingNumberWarning: Bool

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    init(isCrewMemberNonEmpty: Binding<Bool>,
         informationComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>,
         crewMember: CrewMemberViewModel,
         reportId: String,
         index: Int = 0,
         isCaptain: Bool = false,
         removeClicked: ((CrewMemberViewModel) -> Void)? = nil) {

        _isCrewMemberNonEmpty = isCrewMemberNonEmpty
        _informationComplete = informationComplete
        _showingWarningState = showingWarningState

        self.crewMember = crewMember
        self.reportId = reportId
        self.index = index
        self.isCaptain = isCaptain
        self.removeClicked = removeClicked

        _showingNameWarning = .constant(showingWarningState.wrappedValue && crewMember.name.isEmpty)
        _showingNumberWarning = .constant(showingWarningState.wrappedValue && crewMember.license.isEmpty)
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: isCaptain ? "Captain" : "Crew Member \(index)")
                AddAttachmentsButton(attachments: crewMember.attachments, reportId: reportId)
            }
                .padding(.top, Dimensions.spacing)
            InputField(title: isCaptain ? "Captain's Name" : "Crew Member Name",
                text: self.$crewMember.name,
                showingWarning: showingNameWarning,
                inputChanged: inputChanged)
            InputField(title: "License Number",
                text: self.$crewMember.license,
                showingWarning: showingNumberWarning,
                inputChanged: inputChanged)
            AttachmentsView(attachments: crewMember.attachments)
            if !isCaptain {
                SectionButton(title: NSLocalizedString("Remove", comment: "") + " \(crewMember.name)",
                    systemImageName: "minus",
                    callingToAction: false,
                    action: { self.removeClicked?(self.crewMember) })
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }

    private func inputChanged(_ value: String) {
        updateCrewMemberStatus()
        self.checkAllInput()
    }

    private func updateCrewMemberStatus() {
        self.isCrewMemberNonEmpty = !self.crewMember.isEmpty
    }

    private func checkAllInput() {
        showingNameWarning = showingWarningState && crewMember.name.isEmpty
        showingNumberWarning = showingWarningState && crewMember.license.isEmpty
        informationComplete = crewMember.isComplete
    }
}

struct CrewMemberInputView_Previews: PreviewProvider {
    static var crewNoNotes = CrewMemberViewModel()
    static var previews: some View {
        Group {
            CrewMemberInputView(isCrewMemberNonEmpty: .constant(true),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                crewMember: .sample,
                reportId: "TestID",
                isCaptain: true)
            CrewMemberInputView(isCrewMemberNonEmpty: .constant(true),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                crewMember: .sample,
                reportId: "TestID",
                isCaptain: false)
            CrewMemberInputView(isCrewMemberNonEmpty: .constant(true),
                informationComplete: .constant(false),
                showingWarningState: .constant(true),
                crewMember: .sample,
                reportId: "TestID",
                isCaptain: false)
            VStack {
                CrewMemberInputView(isCrewMemberNonEmpty: .constant(true),
                    informationComplete: .constant(true),
                    showingWarningState: .constant(false),
                    crewMember: crewNoNotes,
                    reportId: "TestID",
                    isCaptain: true)
                Divider()
            }
        }
    }
}
