//
//  VesselView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselView: View {
    @ObservedObject var vessel: BoatViewModel
    let reportId: String

    @State private var activeEditableComponentId: String
    @State private var showingAddEMSButton: Bool
    @Binding private var showingPrefilledAlert: Bool
    @Binding private var allFieldsComplete: Bool
    @State private var initialVessel = BoatViewModel()

    @State private var informationComplete: Bool
    @State private var deliveryComplete: Bool
    @State private var emsComplete: Bool

    @Binding private var showingWarningState: Bool

    init(vessel: BoatViewModel,
         reportId: String,
         prefilledVesselAvailable: Binding<Bool>,
         allFieldsComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>) {

        self.vessel = vessel
        self.reportId = reportId
        _activeEditableComponentId = State(initialValue: vessel.id)
        _showingAddEMSButton = State(initialValue: vessel.ems.filter({ $0.isEmpty }).isEmpty)
        _showingPrefilledAlert = prefilledVesselAvailable
        _allFieldsComplete = allFieldsComplete

        _informationComplete = State(initialValue: false)
        _deliveryComplete = State(initialValue: false)
        _emsComplete = State(initialValue: false)
        _showingWarningState = showingWarningState
    }

    private enum Dimensions {
        static let itemsSpacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 8.0
    }

    var body: some View {
        KeyboardControllingScrollView {
            Group {
                VStack(spacing: Dimensions.itemsSpacing) {
                    VesselInformationView(
                        vessel: self.vessel,
                        reportId: self.reportId,
                        activeEditableComponentId: self.$activeEditableComponentId,
                        informationComplete:
                            Binding<Bool>(get: { self.informationComplete },
                                set: {
                                    self.informationComplete = $0
                                    self.checkAllInput()
                                }),
                        showingWarningState: self.$showingWarningState)

                    DeliveryView(
                        delivery: self.vessel.lastDelivery,
                        reportId: self.reportId,
                        activeEditableComponentId: self.$activeEditableComponentId,
                        informationComplete:
                            Binding<Bool>(get: { self.deliveryComplete },
                                set: {
                                    self.deliveryComplete = $0
                                    self.checkAllInput()
                                }),
                        showingWarningState: self.$showingWarningState)

                    VStack(spacing: Dimensions.itemsSpacing) {
                        ForEach(self.vessel.ems) { ems in
                            EMSView(
                                ems: ems,
                                reportId: self.reportId,
                                activeEditableComponentId: self.$activeEditableComponentId,
                                isEmsNonEmpty: self.$showingAddEMSButton,
                                deleteClicked: self.emsDeleteClicked)
                        }
                    }
                }
                    .alert(isPresented: self.$showingPrefilledAlert) {
                        Alert(title: Text("Prefill Vessel Information From Previous Boarding?"),
                            message: Text("You'll still be able to edit fields"),
                            primaryButton: .default(Text("No")) {
                                self.showingPrefilledAlert = false
                            },
                            secondaryButton: .default(Text("Prefill"), action: self.prefillVesselInformationClicked)
                        )
                    }

                if self.showingAddEMSButton {
                    SectionButton(title: "Add Electronic Monitoring System",
                        systemImageName: "plus") {
                        self.addEMSClicked()
                    }
                        .padding(.top, Dimensions.bottomPadding)
                        .padding(.bottom, Dimensions.bottomPadding + Dimensions.itemsSpacing)
                }
            }
        }
            .onAppear(perform: self.onAppear)
    }

    /// Actions

    private func onAppear() {
        if self.showingPrefilledAlert {
            self.initialVessel.name = self.vessel.name.copy() as? String ?? ""
            self.initialVessel.permitNumber = self.vessel.permitNumber.copy() as? String ?? ""
            self.initialVessel.nationality = self.vessel.nationality.copy() as? String ?? ""
            self.initialVessel.homePort = self.vessel.homePort.copy() as? String ?? ""

            self.vessel.name = ""
            self.vessel.nationality = ""
            self.vessel.permitNumber = ""
            self.vessel.homePort = ""
        }
    }

    private func emsDeleteClicked(_ id: String) {
        self.vessel.ems.removeAll(where: { $0.id == id })
        self.showingAddEMSButton = self.vessel.ems.filter({ $0.isEmpty }).isEmpty
    }

    private func addEMSClicked() {
        self.showingAddEMSButton = false
        let emsModel = EMSViewModel()
        self.activeEditableComponentId = emsModel.id
        self.vessel.ems.append(emsModel)
    }

    private func prefillVesselInformationClicked() {
        self.vessel.name = self.initialVessel.name
        self.vessel.permitNumber = self.initialVessel.permitNumber
        self.vessel.homePort = self.initialVessel.homePort
        self.vessel.nationality = self.initialVessel.nationality
        self.showingPrefilledAlert = false
        informationComplete = !vessel.isEmpty
    }

    /// Logic

    private func checkAllInput() {
        allFieldsComplete = informationComplete && deliveryComplete
    }
}

struct VesselView_Previews: PreviewProvider {
    static var previews: some View {
        VesselView(
            vessel: .sample,
            reportId: "TestId",
            prefilledVesselAvailable: .constant(true),
            allFieldsComplete: .constant(false),
            showingWarningState: .constant(false))
    }
}
