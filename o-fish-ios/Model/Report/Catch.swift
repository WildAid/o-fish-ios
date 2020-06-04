//
//  Catch.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Catch: EmbeddedObject, ObservableObject {
    @objc dynamic var fish = ""
    @objc dynamic var number = 0
    @objc dynamic var weight = 0.0
    @objc dynamic var unit = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
