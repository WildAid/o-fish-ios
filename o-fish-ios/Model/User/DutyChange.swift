//
//  DutyChange.swift
//
//  Created on 25/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class DutyChange: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    // TODO: Remove when no longer required by MongoDB Realm Sync
    @objc dynamic var agency = ""
    @objc dynamic var user: User? = User()
    @objc dynamic var date = Date()
    @objc dynamic var status = ""

    convenience init(id: String) {
        self.init()
        do {
            try _id = ObjectId(string: id)
        } catch {
            _id = ObjectId.generate()
        }
    }

    override static func primaryKey() -> String? {
        return "_id"
    }
}
