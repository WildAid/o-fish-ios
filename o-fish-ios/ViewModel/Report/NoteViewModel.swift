//
//  NoteViewModel.swift
//  
//  Created on 20/10/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class NoteViewModel: Identifiable, ObservableObject {
    @Published var id = UUID().uuidString
    @Published var text = ""
    // TODO: Remove this when the iOS array indexing bug is fixed
    @Published var isArchived = false

    var isEmpty: Bool {
        text.isEmpty || isArchived
    }

    convenience init(id: String = UUID().uuidString, text: String) {
        self.init()
        self.id = id
        self.text = text
    }
}
