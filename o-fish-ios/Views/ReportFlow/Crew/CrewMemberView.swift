//
//  CrewMemberModel.swift
//
//  Created on 3/10/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CrewMemberView: View {
    @Binding var isCrewMemberNonEmpty: Bool
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool

    @ObservedObject var crewMember: CrewMemberViewModel
    let reportId: String

    var index: Int = 0

    var editClicked: ((CrewMemberViewModel) -> Void)?
    var removeClicked: ((CrewMemberViewModel) -> Void)?

    var body: some View {
        wrappedShadowView {
            CrewMemberInputView(isCrewMemberNonEmpty: self.$isCrewMemberNonEmpty,
                informationComplete: $informationComplete,
                showingWarningState: $showingWarningState,
                crewMember: crewMember,
                reportId: reportId,
                index: index,
                isCaptain: crewMember.isCaptain,
                removeClicked: removeClicked)
        }
    }
}

struct CrewMemberView_Previews: PreviewProvider {
    static private let crewMember = CrewMemberViewModel.sample

    static var previews: some View {
        VStack {
            CrewMemberView(
                isCrewMemberNonEmpty: .constant(false),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                crewMember: .sample,
                reportId: "TestId",
                index: 1
            )
            CrewMemberView(
                isCrewMemberNonEmpty: .constant(false),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                crewMember: crewMember,
                reportId: "TestId",
                index: 1
            )
        }
    }
}
