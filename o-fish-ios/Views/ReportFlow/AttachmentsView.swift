//
//  AttachmentsView.swift
//
//  Created on 5/22/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AttachmentsView: View {
    @ObservedObject var attachments: AttachmentsViewModel
    var isEditable = true

    private let spacing: CGFloat = 16.0

    var body: some View {
        VStack(spacing: spacing) {
            if !attachments.notes.isEmpty {
                NotesListView(attachments: attachments,
                              isEditable: isEditable,
                              deleteNote: deleteNote)
            }

            if !attachments.photoIDs.isEmpty {
                PhotoIDsDisplayView(photoIDs: attachments.photoIDs,
                                    deletePhoto: isEditable ? deletePhoto : nil)
            }
        }
    }

    private func deleteNote(id: String) {
        attachments.notes.removeAll(where: { $0.id == id })
    }

    private func deletePhoto(photo: PhotoViewModel) {
        attachments.photoIDs.removeAll(where: { $0.id == photo.id })
        photo.delete()
    }
}

struct AttachmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentsView(attachments: .sample)
    }
}
