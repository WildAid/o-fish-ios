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
        Button(action: { self.showAttachmentTypeModal() }) {
            AddAttachmentIconView()
        }
    }

    private func hidePopover() {
        PopoverManager.shared.hidePopover(id: popoverId)
    }

    private func showAttachmentTypeModal() {
        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available

        PopoverManager.shared.showPopover(id: popoverId, withButton: false) {
                ModalView(buttons: [
                    ModalViewButton(title: NSLocalizedString("Photo", comment: ""), action: showPhotoPickerTypeModal),
                    ModalViewButton(title: NSLocalizedString("Note", comment: ""), action: addNote)
                ],
                    cancel: hidePopover)
        }
    }

    private func showPhotoPickerTypeModal() {
        hidePopover()

        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available

        PopoverManager.shared.showPopover(id: popoverId, withButton: false) {
            ModalView(buttons: [
                ModalViewButton(title: NSLocalizedString("Camera", comment: ""), action: { self.showPhotoTaker(source: .camera) }),
                ModalViewButton(title: NSLocalizedString("Photo Library", comment: ""), action: { self.showPhotoTaker(source: .photoLibrary) })
            ],
                cancel: hidePopover)
        }
    }

    /// Logic

    private func showPhotoTaker(source: UIImagePickerController.SourceType) {
        hidePopover()
        PhotoCaptureController.show(reportID: reportId, source: source) { controller, photoId in
            self.attachments.photoIDs.append(photoId)
            controller.hide()
        }
    }

    private func addNote() {
        hidePopover()
        attachments.notes.append(Note(text: ""))
    }
}

struct AddAttachmentsButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAttachmentsButton(attachments: .sample, reportId: "TestID")
    }
}
