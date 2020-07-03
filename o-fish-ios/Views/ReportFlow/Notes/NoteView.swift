//
//  NoteView.swift
//
//  Created on 16/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var annotatedNote: AnnotatedNoteViewModel
    var noteIndex: Int
    @Binding var activeNoteId: String
    let reportID: String

    var deleteClicked: ((AnnotatedNoteViewModel) -> Void)?

    var body: some View {
        wrappedShadowView {
            if activeNoteId == annotatedNote.id {
                NoteInputView(annotatedNote: annotatedNote, noteIndex: noteIndex, reportID: reportID, deleteClicked: deleteClicked)
            } else {
                NoteStaticView(annotatedNote: annotatedNote, noteIndex: noteIndex, activeNoteId: $activeNoteId)
            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        let note1: AnnotatedNoteViewModel = .sample
        note1.setId("123")
        return VStack {
            NoteView(annotatedNote: note1, noteIndex: 0, activeNoteId: .constant("123"), reportID: "12345")
            NoteView(annotatedNote: .sample, noteIndex: 1, activeNoteId: .constant("123"), reportID: "12345")
        }
    }
}
