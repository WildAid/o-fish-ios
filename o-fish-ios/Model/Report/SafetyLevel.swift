//
//  SafetyLevel.swift
//
//  Created on 09/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class SafetyLevel: EmbeddedObject, ObservableObject {
    @objc dynamic var level = ""
    @objc dynamic var amberReason = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
