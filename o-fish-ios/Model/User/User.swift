//
//  User.swift
//
//  Created on 25/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class User: EmbeddedObject {
    @objc dynamic var name: Name? = Name()
    @objc dynamic var email = ""
}
