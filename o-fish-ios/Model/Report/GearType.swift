//
//  GearType.swift
//
//  Created on 08/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class GearType: EmbeddedObject, ObservableObject {
    @objc dynamic var name = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
