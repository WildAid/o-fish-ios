//
//  EMS.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class EMS: EmbeddedObject, ObservableObject {
    @objc dynamic var emsType = ""
    @objc dynamic var emsDescription = ""
    @objc dynamic var registryNumber = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
