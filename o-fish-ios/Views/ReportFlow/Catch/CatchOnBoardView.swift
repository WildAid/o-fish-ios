//
//  CatchOnBoardView.swift
//
//  Created on 21/04/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CatchOnBoardView: View {
    @Binding var currentEditingCatchId: String
    @Binding var isCatchNonEmpty: Bool
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool
    @ObservedObject var catchModel: CatchViewModel
    let reportId: String
    let index: Int

    var removeClicked: ((CatchViewModel) -> Void)?

    var body: some View {
            wrappedShadowView {
                if catchModel.id == currentEditingCatchId {
                    CatchInputView(isCatchNonEmpty: self.$isCatchNonEmpty,
                        informationComplete: self.$informationComplete,
                        showingWarningState: self.$showingWarningState,
                        catchModel: catchModel,
                        reportId: reportId,
                        index: index,
                        removeClicked: removeClicked)
                } else {
                    CatchStaticView(catchModel: catchModel,
                        index: index,
                        editClicked: { violation in
                            self.currentEditingCatchId = violation.id
                        })
                }
            }
    }
}

struct CatchOnBoard_Previews: PreviewProvider {
    static private let catchModel = CatchViewModel.sample

    static var previews: some View {
        VStack {
            CatchOnBoardView(
                currentEditingCatchId: .constant("1"),
                isCatchNonEmpty: .constant(false),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                catchModel: .sample,
                reportId: "TestId",
                index: 1
            )
            CatchOnBoardView(
                currentEditingCatchId: .constant(catchModel.id),
                isCatchNonEmpty: .constant(false),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                catchModel: catchModel,
                reportId: "TestId",
                index: 1
            )
        }
    }
}
