//
//  AnnotatedNoteViewModel.swift
//
//  Created on 16/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class AnnotatedNoteViewModel: ObservableObject, Identifiable {

    private var annotatedNote: AnnotatedNote?

    @Published var id = UUID().uuidString
    @Published var note = ""
    @Published var photoIDs: [String] = []

    var isEmpty: Bool {
        note.isEmpty && photoIDs.isEmpty
    }

    convenience init (_ annotatedNote: AnnotatedNote?) {
        self.init()
        if let annotatedNote = annotatedNote {
            self.annotatedNote = annotatedNote
            self.note = annotatedNote.note
            for index in annotatedNote.photoIDs.indices {
                photoIDs.append(annotatedNote.photoIDs[index])
            }
        } else {
            self.annotatedNote = AnnotatedNote()
        }
    }

    func save() -> AnnotatedNote? {
        if annotatedNote == nil {
            annotatedNote = AnnotatedNote()
        }
        guard let annotatedNote = annotatedNote else { return nil }
        annotatedNote.photoIDs.removeAll()
        photoIDs.forEach { photoID in
            annotatedNote.photoIDs.append(photoID)
        }
        annotatedNote.note = note
        return annotatedNote
    }
}

extension AnnotatedNoteViewModel {

    // Needed for SwiftUI preview
    func setId (_ id: String) {
        self.id = id
    }
}
