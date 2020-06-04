//
//  NotesSummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct NotesSummaryView: View {

    private enum Dimensions {
        static let bottomPadding: CGFloat = 24.0
        static let spacing: CGFloat = 16.0
    }

    var notes: [AnnotatedNoteViewModel]
    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            TitleLabel(title: "Notes")
                .padding(.top, Dimensions.spacing)
            ForEach(notes.enumeratedArray(), id: \.element.id) { (index, note) in

                VStack(spacing: Dimensions.spacing) {
                    LabeledText(label: NSLocalizedString("Note", comment: "") + " \(index + 1)", text: "\(note.note)")
                    if !note.photoIDs.isEmpty {
                        PhotoIDsDisplayView(photoIDs: note.photoIDs)
                    }
                    if self.notes.count > index + 1 { Divider() }
                }
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct NotesSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        return NotesSummaryView(notes: [.sample, .sample])
    }
}
