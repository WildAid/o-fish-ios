//
//  Photo.swift
//
//  Createdan on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Photo: Object {

    @objc dynamic var _id: ObjectId = ObjectId.generate()
    // TODO: Remove when no longer required by MongoDB Realm Sync
    @objc dynamic var agency = ""
    @objc dynamic var thumbNail: NSData?
    @objc dynamic var picture: NSData?
    @objc dynamic var pictureURL = ""
    @objc dynamic var referencingReportID = ""
    @objc dynamic var date = NSDate()

    convenience init(id: String) {
        self.init()
        do {
            try _id = ObjectId(string: id)
        } catch { _id = ObjectId.generate() }
    }

    override static func primaryKey() -> String? {
        return "_id"
    }
}
