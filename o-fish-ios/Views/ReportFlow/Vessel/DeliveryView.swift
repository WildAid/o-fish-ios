//
//  DeliveryView.swift
//
//  Created on 4/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DeliveryView: View {

    @ObservedObject var delivery: DeliveryViewModel
    @Binding var activeEditableComponentId: String
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool

    var body: some View {
        wrappedShadowView {
            VStack {
                if activeEditableComponentId == delivery.id || delivery.isEmtpy {
                    DeliveryInputView(delivery: delivery,
                        activeEditableComponentId: $activeEditableComponentId,
                        informationComplete: $informationComplete,
                        showingWarningState: $showingWarningState)
                } else {
                    LastDeliverySummaryView(delivery: delivery, isEditable: true) {
                        self.activeEditableComponentId = self.delivery.id
                    }
                }
            }
        }
    }
}

struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DeliveryView(delivery: .sample,
                activeEditableComponentId: .constant(""),
                informationComplete: .constant(false),
                showingWarningState: .constant(false))

            Divider()

            DeliveryView(delivery: .sample,
                activeEditableComponentId: .constant("123"),
                informationComplete: .constant(false),
                showingWarningState: .constant(false))
        }
    }
}
