//
//  Inspection.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Inspection: EmbeddedObject, ObservableObject {
    @objc dynamic var activity: Activity? = Activity()
    @objc dynamic var fishery: Fishery? = Fishery()
    @objc dynamic var gearType: GearType? = GearType()
    let actualCatch = List<Catch>()
    @objc dynamic var summary: Summary? = Summary()
    @objc dynamic var attachments: Attachments? = Attachments()
}
