//
//  NotesListView.swift
//
//  Created on 5/22/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct NotesListView: View {
    @ObservedObject var attachments: AttachmentsViewModel

    var isEditable = true
    var deleteNote: ((String) -> Void)?
    private let spacing: CGFloat = 16.0

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(self.attachments.notes.indices, id: \.self) { index in
                if !self.attachments.notes[index].isArchived {
                    NoteFieldView(note: self.$attachments.notes[index],
                                  isEditable: self.isEditable,
                                  delete: self.deleteNote)
                }
            }
        }
    }

    private func deleteNote(id: String) {
        deleteNote?(id)
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotesListView(attachments: .sample)
            NotesListView(attachments: .sample, isEditable: false)
        }
    }
}
