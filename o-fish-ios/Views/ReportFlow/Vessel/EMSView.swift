//
//  EMSView.swift
//
//  Created on 4/17/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EMSView: View {
    @ObservedObject var ems: EMSViewModel

    @Binding var activeEditableComponentId: String
    @Binding var isEmsNonEmpty: Bool
    var deleteClicked: ((String) -> Void)?

    var body: some View {
        wrappedShadowView {
            if activeEditableComponentId == ems.id || ems.isEmpty {
                EMSInputView(ems: ems,
                             activeEditableComponentId: $activeEditableComponentId,
                             isEmsNonEmpty: $isEmsNonEmpty,
                             deleteClicked: deleteClicked)
            } else {
                EMSSummaryView(ems: ems, isEditable: true) {
                    self.activeEditableComponentId = self.ems.id
                }
                    .removable {
                        self.deleteClicked?(self.ems.id)
                    }
            }
        }
    }
}

struct EMSView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EMSView(ems: .sample,
                    activeEditableComponentId: .constant("123"),
                    isEmsNonEmpty: .constant(true),
                    deleteClicked: nil)
            Divider()
            EMSView(ems: .sample,
                    activeEditableComponentId: .constant(""),
                    isEmsNonEmpty: .constant(true),
                    deleteClicked: nil)
        }
    }
}
