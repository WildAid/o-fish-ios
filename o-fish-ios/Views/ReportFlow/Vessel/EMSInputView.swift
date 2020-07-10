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
    let reportId: String

    var deleteClicked: ((String) -> Void)?

    @State private var showingChooseEMSPicker = false

    private enum Dimensions {

        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: "Electronic Monitoring System")
                AddAttachmentsButton(attachments: ems.attachments, reportId: reportId)
            }
                .padding(.top, Dimensions.spacing)

            ButtonField(title: "EMS Type", text: self.ems.emsType, fieldButtonClicked: {
                self.showingChooseEMSPicker.toggle()
                self.activeEditableComponentId = self.ems.id
            })
                .sheet(isPresented: $showingChooseEMSPicker) {
                    ChooseEMSView(selectedItem:
                        Binding<String>(
                            get: { self.ems.emsType },
                            set: {
                                self.ems.emsType = $0
                                if self.ems.emsType != "Other" {
                                    self.ems.emsDescription = ""
                                }
                                self.isEmsNonEmpty = !self.ems.isEmpty
                        })
                    )
            }

            if ems.emsType == "Other" {
                InputField(title: "Description", text: $ems.emsDescription)
            }

            InputField(title: "Registry Number", text: Binding<String>(
                get: {
                    self.ems.registryNumber
            },
                set: {
                    self.ems.registryNumber = $0
                    self.isEmsNonEmpty = !self.ems.isEmpty
            }
            ))

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
}

struct EMSInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EMSInputView(ems: EMSViewModel.sample,
                         activeEditableComponentId: .constant("123"),
                         isEmsNonEmpty: .constant(true),
                         reportId: "TestID")
        }
    }
}
