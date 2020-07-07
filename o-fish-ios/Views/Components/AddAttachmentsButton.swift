//
//  AddAttachmentsButton.swift
//
//  Created on 5/21/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AddAttachmentsButton: View {
    @ObservedObject var attachments: AttachmentsViewModel

    @State private var popoverId = UUID().uuidString
    let reportId: String

    var body: some View {
        Button(action: { self.showCustomActionSheet() }) {
            AddAttachmentIconView()
        }
    }

    private func showPhotoTaker() {
        hidePopover()
        PhotoCaptureController.show(reportID: reportId) { controller, photoId in
            self.attachments.photoIDs.append(photoId)
            controller.hide()
        }
    }

    private func addNote() {
        hidePopover()
        attachments.notes.append(Note(text: ""))
    }

    private func hidePopover() {
        PopoverManager.shared.hidePopover(id: popoverId)
    }

    private func showCustomActionSheet() {
        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available

        PopoverManager.shared.showPopover(id: popoverId, withButton: false) {
            AddAttachmentsModalView(photo: showPhotoTaker,
                                    note: addNote,
                                    cancel: hidePopover)
                .background(Color.blackWithOpacity)
                .onTapGesture {
                    self.hidePopover()
            }
        }
    }
}

struct AddAttachmentsButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAttachmentsButton(attachments: .sample, reportId: "TestID")
    }
}
