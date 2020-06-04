//
//  SeizuresViewModel.swift
//
//  Created on 09/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class SeizuresViewModel: ObservableObject, Identifiable {
    private var seizures: Seizures?

    @Published var id = UUID().uuidString
    @Published var description = ""
    @Published var attachments = AttachmentsViewModel()

    convenience init(_ seizures: Seizures?) {
        self.init()
        if let seizures = seizures {
            self.seizures = seizures
            description = seizures.text
            attachments = AttachmentsViewModel(seizures.attachments)
        } else {
            self.seizures = Seizures()
        }
    }

    func save() -> Seizures? {
        if seizures == nil {
            seizures = Seizures()
        }
        guard let seizures = seizures else { return nil }

        seizures.text = description
        seizures.attachments = attachments.save()
        return seizures
    }
}
