//
//  Name.swift
//
//  Created on 25/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Name: EmbeddedObject {
    @objc dynamic var first = ""
    @objc dynamic var last = ""
}
