//
//  Seizures.swift
//
//  Created on 09/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Seizures: EmbeddedObject, ObservableObject {
    @objc dynamic var text = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
