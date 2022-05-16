//
//  Delivery.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Delivery: EmbeddedObject {
    @objc dynamic var date = NSDate(timeIntervalSince1970: 0)
    @objc dynamic var location = ""
    @objc dynamic var business = ""
    @objc dynamic var attachments: Attachments? = Attachments()
}
