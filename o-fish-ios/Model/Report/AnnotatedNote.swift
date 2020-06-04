//
//  AnnotatedNote.swift
//
//  Created on 16/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class AnnotatedNote: EmbeddedObject, ObservableObject, Identifiable {
    @objc dynamic var note = ""
    let photoIDs = List<String>()
}
