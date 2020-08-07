//
//  EMSView.swift
//
//  Created on 4/17/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EMSView: View {
    @ObservedObject var ems: EMSViewModel
    let reportId: String

    @Binding var activeEditableComponentId: String
    @Binding var isEmsNonEmpty: Bool
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool
    var deleteClicked: ((String) -> Void)?

    var body: some View {
        wrappedShadowView {
            if activeEditableComponentId == ems.id || ems.isEmpty {
                EMSInputView(ems: ems,
                    activeEditableComponentId: $activeEditableComponentId,
                    isEmsNonEmpty: $isEmsNonEmpty,
                    informationComplete: $informationComplete,
                    showingWarningState: $showingWarningState,
                    reportId: reportId,
                    deleteClicked: deleteClicked)
            } else {
                EMSSummaryView(ems: ems, isEditable: true) {
                    self.activeEditableComponentId = self.ems.id
                }
            }
        }
    }
}

struct EMSView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EMSView(ems: .sample,
                reportId: "TestId",
                activeEditableComponentId: .constant("123"),
                isEmsNonEmpty: .constant(true),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                deleteClicked: nil)
            Divider()
            EMSView(ems: .sample,
                reportId: "TestId",
                activeEditableComponentId: .constant(""),
                isEmsNonEmpty: .constant(true),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                deleteClicked: nil)
        }
    }
}
