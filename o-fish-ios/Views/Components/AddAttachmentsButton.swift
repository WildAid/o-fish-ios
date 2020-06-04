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
    @State private var newPhotoID = ""

    var body: some View {
        Button(action: { self.showingActionSheet.toggle() }) {
            AddAttachmentIconView()
        }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Choose the type of attachments"),
                            message: nil,
                            buttons: [.default(Text("Photo")) { self.showingPhotoTaker = true },
                                      .default(Text("Note")) {
                                        self.attachments.notes.append(Note(text: ""))
                                },
                                      .default(Text("Cancel"))])
            }
            .sheet(isPresented: $showingPhotoTaker) {
                PhotoCaptureView(
                    showingPhotoTaker: self.$showingPhotoTaker,
                    photoID: self.$newPhotoID,
                    reportID: self.attachments.id,
                    photoTaken: {
                        self.attachments.photoIDs.append(self.newPhotoID)
                }
                )
            }
    }
}

struct AddAttachmentsButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAttachmentsButton(attachments: .sample)
    }
}
