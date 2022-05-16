//
//  Violation.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Violation: EmbeddedObject {
    @objc dynamic var disposition = ""
    @objc dynamic var offence: Offence? = Offence()
    @objc dynamic var crewMember: CrewMember? = CrewMember()
    @objc dynamic var attachments: Attachments? = Attachments()
}
