//
//  MenuData.swift
//
//  Created on 17/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class MenuData: Object {
    @objc dynamic var _id = ObjectId.generate()
    let countryPickerPriorityList = List<String>()
    let ports = List<String>()
    let fisheries = List<String>()
    let species = List<String>()
    let emsTypes = List<String>()
    let activities = List<String>()
    let gear = List<String>()
    let violationCodes = List<String>()
    let violationDescriptions = List<String>()

    override static func primaryKey() -> String? {
        return "_id"
    }
}
