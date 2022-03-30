//
//  NotesView.swift
//
//  Created on 06/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    @ObservedObject var report: ReportViewModel
    @Binding var allFieldsComplete: Bool

    @State private var activeNoteId = ""

    private enum Dimensions {
        static let verticalPadding: CGFloat = 24.0
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        KeyboardControllingScrollView {
            Group {
                VStack(spacing: Dimensions.spacing) {
                    ForEach(self.report.notes.enumeratedArray(), id: \.element.id) { (index, member) in
                        NoteView(
                            annotatedNote: member,
                            noteIndex: index,
                            activeNoteId: self.$activeNoteId,
                            reportID: self.report.id,
                            deleteClicked: self.deleteNote)
                    }
                }

                SectionButton(title: "Add Note", systemImageName: "plus", action: self.addNote)
                    .padding(.vertical, Dimensions.verticalPadding)

                // TODO: Should be revisited after the June 2020 SwiftUI improvements
                HStack {
                    Spacer()
                }
                Spacer()
            }
        }
            .background(Color.oBackground)
            .onAppear(perform: { self.allFieldsComplete = true })
    }

    func addNote() {
        let newNote = AnnotatedNoteViewModel()
        self.report.notes.append(newNote)
        self.activeNoteId = newNote.id
    }

    func deleteNote(_ note: AnnotatedNoteViewModel) {
        for photo in note.photoIDs {
            PhotoViewModel.delete(photoID: photo)
        }
        report.notes.removeAll(where: { $0.id == note.id })
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(report: .sample,
            allFieldsComplete: .constant(false))
    }
}
