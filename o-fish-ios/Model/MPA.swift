//
//  MPA.swift
//  
//  Created on 20.05.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import RealmSwift

class MPA: Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var text = ""
    @objc dynamic var info = ""
    @objc dynamic var hexColor = ""
    let coordinates = List<Location>()

    override static func primaryKey() -> String? {
        return "_id"
    }
}
