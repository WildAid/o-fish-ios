//
//  Attachments.swift
//
//  Created on 08/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Attachments: EmbeddedObject, ObservableObject {
    let notes = List<String>()
    let photoIDs = List<String>()
}
