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

    @ObservedObject var catchModel: CatchViewModel
    let index: Int

    var removeClicked: ((CatchViewModel) -> Void)?

    var body: some View {
            wrappedShadowView {
                if catchModel.id == currentEditingCatchId {
                    CatchInputView(isCatchNonEmpty: self.$isCatchNonEmpty,
                        catchModel: catchModel,
                        index: index,
                        removeClicked: removeClicked)
                } else {
                    CatchStaticView(catchModel: catchModel,
                        index: index,
                        editClicked: { violation in
                            self.currentEditingCatchId = violation.id
                        })
                            .removable {
                                self.removeClicked?(self.catchModel)
                        }
                }
            }
    }
}

struct CatchOnBoard_Previews: PreviewProvider {
    static private let catchModel = CatchViewModel.sample

    static var previews: some View {
        VStack {
            CatchOnBoardView(currentEditingCatchId: .constant("1"),
                isCatchNonEmpty: .constant(false),
                catchModel: .sample,
                index: 1
            )
            CatchOnBoardView(currentEditingCatchId: .constant(catchModel.id),
                isCatchNonEmpty: .constant(false),
                catchModel: catchModel,
                index: 1
            )
        }
    }
}
