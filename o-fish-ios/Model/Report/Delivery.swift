//
//  Delivery.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Delivery: EmbeddedObject, ObservableObject {
    @objc dynamic var date = NSDate()
    @objc dynamic var location = ""
    @objc dynamic var business = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
