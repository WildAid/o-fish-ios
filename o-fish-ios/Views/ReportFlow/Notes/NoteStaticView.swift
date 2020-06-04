//
//  NoteStaticView.swift
//
//  Created on 16/04/2020.
//

import SwiftUI

struct NoteStaticView: View {
    @ObservedObject var annotatedNote: AnnotatedNoteViewModel
    let noteIndex: Int
    @Binding var activeNoteId: String

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let bottomPadding: CGFloat = 24
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Dimensions.spacing) {
                HStack {
                    TitleLabel(title: NSLocalizedString("Note", comment: "") + " \(noteIndex + 1)")
                    Button(action: { self.activeNoteId = self.annotatedNote.id }) {
                        EditIconView()
                    }
                }
                    .padding(.top, Dimensions.spacing)

                Text(annotatedNote.note)
                    .fixedSize(horizontal: true, vertical: true)

            if !annotatedNote.photoIDs.isEmpty {
                PhotoIDsDisplayView(photoIDs: annotatedNote.photoIDs)
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct NoteStaticView_Previews: PreviewProvider {
    static var previews: some View {
        NoteStaticView(annotatedNote: .sample, noteIndex: 0, activeNoteId: .constant("123"))
    }
}
