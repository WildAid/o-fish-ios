//
//  Location.swift
//  
//  Created on 25.05.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import CoreLocation
import RealmSwift

class Location: EmbeddedObject {
    @objc dynamic var lat = 0.0
    @objc dynamic var lon = 0.0
}

extension CLLocationCoordinate2D {
    init(coord: Location) {
        self.init(latitude: coord.lat, longitude: coord.lon)
    }
}
