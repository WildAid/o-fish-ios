//
//  CrewMember.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class CrewMember: EmbeddedObject, ObservableObject {
    @objc dynamic var name = ""
    @objc dynamic var license = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
