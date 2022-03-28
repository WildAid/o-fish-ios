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
    @State private var emsComplete: [String: Bool]
    @Binding private var showingAlertItem: AlertItem?
    @Binding private var showingWarningState: Bool

    init(vessel: BoatViewModel,
         reportId: String,
         prefilledVesselAvailable: Binding<Bool>,
         showingAlertItem: Binding<AlertItem?>,
         allFieldsComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>) {

        self.vessel = vessel
        self.reportId = reportId
        _activeEditableComponentId = State(initialValue: vessel.id)
        _showingAddEMSButton = State(initialValue: vessel.ems.filter({ $0.isEmpty }).isEmpty)
        _showingPrefilledAlert = prefilledVesselAvailable
        self._showingAlertItem = showingAlertItem
        _allFieldsComplete = allFieldsComplete

        _informationComplete = State(initialValue: false)
        _deliveryComplete = State(initialValue: false)
        _emsComplete = State(initialValue: [:])
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
                        informationComplete: self.informationCompleteBinding,
                        showingWarningState: self.$showingWarningState)

                    DeliveryView(
                        delivery: self.vessel.lastDelivery,
                        reportId: self.reportId,
                        activeEditableComponentId: self.$activeEditableComponentId,
                        informationComplete: self.deliveryCompleteBinding,
                        showingWarningState: self.$showingWarningState)

                    VStack(spacing: Dimensions.itemsSpacing) {
                        ForEach(self.vessel.ems) { ems in
                            EMSView(
                                ems: ems,
                                reportId: self.reportId,
                                activeEditableComponentId: self.$activeEditableComponentId,
                                isEmsNonEmpty: self.$showingAddEMSButton,
                                informationComplete: self.emsInformationCompleteBinding(ems: ems),
                                showingWarningState: self.$showingWarningState,
                                deleteClicked: self.emsDeleteClicked)
                        }
                    }
                }
                .showingAlert(alertItem: self.$showingAlertItem)

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
            .background(Color.oBackground)
            .onAppear(perform: self.onAppear)
    }

    /// Bindings

    private var informationCompleteBinding: Binding<Bool> {
        Binding<Bool>(get: { self.informationComplete },
            set: {
                self.informationComplete = $0
                self.checkAllInput()
            })
    }

    private var deliveryCompleteBinding: Binding<Bool> {
        Binding<Bool>(get: { self.deliveryComplete },
            set: {
                self.deliveryComplete = $0
                self.checkAllInput()
            })
    }

    private func emsInformationCompleteBinding(ems: EMSViewModel) -> Binding<Bool> {
        Binding<Bool>(get: { self.emsComplete[ems.id] ?? false },
            set: {
                self.emsComplete[ems.id] = $0
                self.checkAllInput()
            })
    }

    /// Actions

    private func onAppear() {
        if showingPrefilledAlert {
            initialVessel.name = vessel.name.copy() as? String ?? ""
            initialVessel.permitNumber = vessel.permitNumber.copy() as? String ?? ""
            initialVessel.nationality = vessel.nationality.copy() as? String ?? ""
            initialVessel.homePort = vessel.homePort.copy() as? String ?? ""
            if !vessel.attachments.photoIDs.isEmpty || !vessel.attachments.notes.isEmpty {
                initialVessel.attachments = vessel.attachments
            }

            vessel.name = ""
            vessel.nationality = ""
            vessel.permitNumber = ""
            vessel.homePort = ""
            vessel.attachments = AttachmentsViewModel()

            if vessel.ems.isEmpty {
                let model = EMSViewModel()
                vessel.ems.append(model)
                emsComplete[model.id] = false
                showingAddEMSButton = false
            }

            if showingAlertItem == nil {
                showingAlertItem = AlertItem(
                    title: "Prefill Vessel Information From Previous Boarding?",
                    message: "You'll still be able to edit fields",
                    primaryButton: .default(Text("No")) { self.showingPrefilledAlert = false },
                    secondaryButton: .default(Text("Prefill")) { self.prefillVesselInformationClicked() }
                )
            }
        }
    }

    private func emsDeleteClicked(_ id: String) {
        emsComplete.removeValue(forKey: id)
        vessel.ems.removeAll(where: { $0.id == id })
        showingAddEMSButton = vessel.ems.filter({ $0.isEmpty }).isEmpty
        checkAllInput()
    }

    private func addEMSClicked() {
        showingAddEMSButton = false
        let emsModel = EMSViewModel()
        activeEditableComponentId = emsModel.id
        vessel.ems.append(emsModel)
        emsComplete[emsModel.id] = false
        checkAllInput()
    }

    private func prefillVesselInformationClicked() {
        vessel.name = initialVessel.name
        vessel.permitNumber = initialVessel.permitNumber
        vessel.homePort = initialVessel.homePort
        vessel.nationality = initialVessel.nationality
        vessel.attachments = initialVessel.attachments
        showingPrefilledAlert = false
        informationComplete = !vessel.isEmpty
    }

    /// Logic

    private func checkAllInput() {
        allFieldsComplete = informationComplete
            && deliveryComplete
            && emsComplete.values.filter { $0 == false }.isEmpty
    }
}

struct VesselView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VesselView(
                vessel: .sample,
                reportId: "TestId",
                prefilledVesselAvailable: .constant(true),
                showingAlertItem: .constant(nil),
                allFieldsComplete: .constant(false),
                showingWarningState: .constant(false))
            VesselView(
                vessel: .sample,
                reportId: "TestId",
                prefilledVesselAvailable: .constant(true),
                showingAlertItem: .constant(.sample),
                allFieldsComplete: .constant(false),
                showingWarningState: .constant(false))
        }
    }
}
