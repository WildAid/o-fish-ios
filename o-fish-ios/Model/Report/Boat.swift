//
//  Boat.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Boat: EmbeddedObject, ObservableObject {
    @objc dynamic var name = ""
    @objc dynamic var homePort = ""
    @objc dynamic var nationality = ""
    @objc dynamic var permitNumber = ""
    let ems = List<EMS>()
    @objc dynamic var lastDelivery: Delivery?
    @objc dynamic var attachments: Attachments? = Attachments()
}
