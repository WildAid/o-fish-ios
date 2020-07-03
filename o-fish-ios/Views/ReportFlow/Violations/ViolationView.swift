//
//  ViolationView.swift
//
//  Created on 21/04/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationView: View {
    @Binding var currentEditingViolationId: String
    @Binding var isViolationNonEmpty: Bool

    var report: ReportViewModel
    var crew: [CrewMemberViewModel]
    @ObservedObject var violation: ViolationViewModel
    let index: Int

    var removeClicked: ((ViolationViewModel) -> Void)?

    var body: some View {
        wrappedShadowView {
            if violation.id == currentEditingViolationId {
                ViolationInputView(isViolationNonEmpty: self.$isViolationNonEmpty,
                                   report: self.report,
                                   crew: crew,
                                   violation: violation,
                                   index: index,
                                   removeClicked: removeClicked)
            } else {
                ViolationStaticView(violation: violation,
                                    index: index,
                                    editClicked: { violation in
                                        self.currentEditingViolationId = violation.id
                })
            }
        }
    }
}

struct ViolationView_Previews: PreviewProvider {
    static private let violation = ViolationViewModel.sample

    static var previews: some View {
        VStack {
            ViolationView(currentEditingViolationId: .constant("1"),
                isViolationNonEmpty: .constant(false),
                report: .sample,
                crew: [.sample, .sample],
                violation: .sample,
                index: 1
            )
            ViolationView(currentEditingViolationId: .constant(violation.id),
                isViolationNonEmpty: .constant(false),
                report: .sample,
                crew: [.sample, .sample],
                violation: violation,
                index: 1
            )
        }
    }
}
