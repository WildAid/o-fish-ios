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
        if !attachments.isEmpty {
            VStack(spacing: spacing) {
                NotesListView(attachments: attachments,
                                  isEditable: isEditable,
                                  deleteNote: deleteNote)
                if !attachments.photoIDs.isEmpty {
                    PhotoIDsDisplayView(photoIDs: attachments.photoIDs,
                                        deletePhoto: isEditable ? deletePhoto : nil)
                }
            }
        }
    }

    private func deleteNote(id: String) {
        // TODO: Add this back if/when SwiftUI bug is fixed
        // attachments.notes.removeAll(where: { $0.id == id })
        attachments.notes.filter({$0.id == id}).first?.isArchived = true
        attachments.refresh()
    }

    private func deletePhoto(photo: PhotoViewModel) {
        attachments.photoIDs.removeAll(where: { $0.id == photo.id })
        photo.delete()
    }
}

struct AttachmentsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AttachmentsView(attachments: .sample)
        }
    }
}
