//
//  Location.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Location: EmbeddedObject, ObservableObject {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
}
