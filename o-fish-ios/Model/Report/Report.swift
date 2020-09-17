//
//  Report.swift
//
//  Created on 14/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Report: Object, Identifiable {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    // To write to this, set `.value`
    let draft = RealmOptional<Bool>()
    @objc dynamic var reportingOfficer: User? = User()
    @objc dynamic var timestamp = NSDate()
    let location = List<Double>()
    @objc dynamic var date: NSDate? = NSDate()
    @objc dynamic var vessel: Boat? = Boat()
    @objc dynamic var captain: CrewMember? = CrewMember()
    let crew = List<CrewMember>()
    let notes = List<AnnotatedNote>()
    @objc dynamic var inspection: Inspection? = Inspection()

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
