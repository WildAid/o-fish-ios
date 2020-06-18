//
//  AddAttachmentsButton.swift
//
//  Created on 5/21/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AddAttachmentsButton: View {
    @ObservedObject var attachments: AttachmentsViewModel

    @State private var showingActionSheet = false
    @State private var showingPhotoTaker = false

    var body: some View {
        Button(action: { self.showingActionSheet.toggle() }) {
            AddAttachmentIconView()
        }
            .actionSheet(isPresented: $showingActionSheet) {
                chooseTypeActionSheet
            }
    }

    private var chooseTypeActionSheet: ActionSheet {
        ActionSheet(title: Text("Choose the type of attachments"),
            message: nil,
            buttons: [.default(Text("Photo")) {
                self.showPhotoTaker()
            },
                .default(Text("Note")) {
                    self.attachments.notes.append(Note(text: ""))
                },
                .default(Text("Cancel"))])
    }

    private func showPhotoTaker() {
        PhotoCaptureController.show(reportID: self.attachments.id) { controller, photoId in
            self.attachments.photoIDs.append(photoId)
            controller.hide()
        }
    }
}

struct AddAttachmentsButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAttachmentsButton(attachments: .sample)
    }
}
