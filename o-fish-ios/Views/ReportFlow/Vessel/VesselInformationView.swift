//
//  VesselInformationView.swift
//
//  Created on 4/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselInformationView: View {

    @ObservedObject var vessel: BoatViewModel
    @Binding var activeEditableComponentId: String
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool

    var body: some View {
        wrappedShadowView {
            if activeEditableComponentId == vessel.id || vessel.isEmpty {
                VesselInformationInputView(vessel: vessel,
                    activeEditableComponentId: $activeEditableComponentId,
                    informationComplete: $informationComplete,
                    showingWarningState: $showingWarningState)
            } else {
                VesselSummaryView(vessel: vessel,
                                  isEditable: true) {
                    self.activeEditableComponentId = self.vessel.id
                }
            }
        }
    }
}

struct VesselInformationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VesselInformationView(vessel: .sample,
                activeEditableComponentId: .constant(""),
                informationComplete: .constant(false),
                showingWarningState: .constant(false))
            Divider()
            VesselInformationView(vessel: .sample,
                activeEditableComponentId: .constant("123"),
                informationComplete: .constant(false),
                showingWarningState: .constant(false))
        }
    }
}
