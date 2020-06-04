//
//  AttachmentsViewModel.swift
//
//  Created on 08/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class AttachmentsViewModel: ObservableObject, Identifiable {

    private var attachments: Attachments?
    @Published var id: String = UUID().uuidString

    @Published var photoIDs: [String] = []
    @Published var notes: [Note] = []

    convenience init (_ attachments: Attachments?) {
        self.init()
        if let attachments = attachments {
            self.attachments = attachments
            for index in attachments.photoIDs.indices {
                photoIDs.append(attachments.photoIDs[index])
            }
            for index in attachments.notes.indices {
                notes.append(Note(text: attachments.notes[index]))
            }
        } else {
            self.attachments = Attachments()
        }
    }

    func save() -> Attachments? {
        if attachments == nil {
            attachments = Attachments()
        }
        guard let attachments = attachments else { return nil }
        attachments.photoIDs.removeAll()
        photoIDs.forEach { photoID in
            attachments.photoIDs.append(photoID)
        }
        attachments.notes.removeAll()
        notes.forEach { note in
            if !note.isEmpty {
                attachments.notes.append(note.text)
            }
        }
        return attachments
    }
}
