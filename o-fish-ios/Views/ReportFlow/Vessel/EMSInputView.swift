//
//  EMSInputView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EMSInputView: View {
    @ObservedObject var ems: EMSViewModel
    @Binding var activeEditableComponentId: String
    @Binding var isEmsNonEmpty: Bool
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool
    let reportId: String

    var deleteClicked: ((String) -> Void)?

    @State private var showingChooseEMSPicker = false

    @Binding private var showingTypeWarning: Bool
    @Binding private var showingDescriptionWarning: Bool
    @Binding private var showingRegistryNumberWarning: Bool

    private enum Dimensions {

        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    init(ems: EMSViewModel,
         activeEditableComponentId: Binding<String>,
         isEmsNonEmpty: Binding<Bool>,
         informationComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>,
         reportId: String,
         deleteClicked: ((String) -> Void)? = nil) {

        self.ems = ems
        _activeEditableComponentId = activeEditableComponentId
        _isEmsNonEmpty = isEmsNonEmpty
        _informationComplete = informationComplete
        _showingWarningState = showingWarningState

        self.reportId = reportId
        self.deleteClicked = deleteClicked

        _showingTypeWarning = .constant(showingWarningState.wrappedValue && ems.emsType.isEmpty)
        _showingDescriptionWarning = .constant(ems.emsType == "Other" ? (showingWarningState.wrappedValue && ems.emsDescription.isEmpty) : false)
        _showingRegistryNumberWarning = .constant(showingWarningState.wrappedValue && ems.registryNumber.isEmpty)
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: "Electronic Monitoring System")
                AddAttachmentsButton(attachments: ems.attachments, reportId: reportId)
            }
                .padding(.top, Dimensions.spacing)

            ButtonField(title: "EMS Type",
                text: self.ems.emsType,
                showingWarning: showingTypeWarning,
                fieldButtonClicked: emsTypeClicked)
                .sheet(isPresented: $showingChooseEMSPicker) {
                    ChooseEMSView(selectedItem: self.emsBinding)
            }

            if ems.emsType == "Other" {
                InputField(title: "Description", text: emsDescriptionBinding, showingWarning: showingDescriptionWarning)
            }

            InputField(title: "Registry Number", text: registryNumberBinding, showingWarning: showingRegistryNumberWarning)

            if !ems.attachments.photoIDs.isEmpty || !ems.attachments.notes.isEmpty {
                AttachmentsView(attachments: ems.attachments)
            }

            SectionButton(title: "Remove EMS",
                          systemImageName: "minus",
                          callingToAction: false,
                          action: { self.deleteClicked?(self.ems.id) })
                .padding(.bottom, Dimensions.bottomPadding)

        }
            .contentShape(Rectangle())
            .onTapGesture {
                self.activeEditableComponentId = self.ems.id
            }
    }

    private var emsBinding: Binding<String> {
        Binding<String>(
            get: { self.ems.emsType },
            set: {
                self.ems.emsType = $0
                if self.ems.emsType != "Other" {
                    self.ems.emsDescription = ""
                }
                self.checkAllInput()
            })
    }

    private var emsDescriptionBinding: Binding<String> {
        Binding<String>(
            get: {
                self.ems.emsDescription
            },
            set: {
                self.ems.emsDescription = $0
                self.checkAllInput()
            }
        )
    }

    private var registryNumberBinding: Binding<String> {
        Binding<String>(
            get: {
                self.ems.registryNumber
            },
            set: {
                self.ems.registryNumber = $0
                self.checkAllInput()
            }
        )
    }

    /// Actions

    private func emsTypeClicked() {
        self.showingChooseEMSPicker.toggle()
        self.activeEditableComponentId = self.ems.id
    }

    /// Logic

    private func checkAllInput() {
        self.isEmsNonEmpty = !self.ems.isEmpty

        showingTypeWarning = showingWarningState && ems.emsType.isEmpty
        showingDescriptionWarning = ems.emsType == "Other" ? (showingWarningState && ems.emsDescription.isEmpty) : false
        showingRegistryNumberWarning = showingWarningState && ems.registryNumber.isEmpty

        informationComplete = ems.isComplete
    }
}

struct EMSInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EMSInputView(ems: EMSViewModel.sample,
                activeEditableComponentId: .constant("123"),
                isEmsNonEmpty: .constant(true),
                informationComplete: .constant(false),
                showingWarningState: .constant(false),
                reportId: "TestID")
        }
    }
}
