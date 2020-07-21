//
//  LocationViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import MapKit
import RealmSwift

class LocationViewModel: ObservableObject, Identifiable {
    private var locationModel: List<Double>?

    @Published var id = UUID().uuidString
    @Published var latitude: Double
    @Published var longitude: Double

    var location: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set(location) {
            latitude = location.latitude
            longitude = location.longitude
        }
    }

    required init() {
        let location = LocationHelper.currentLocation
        latitude = location.latitude
        longitude = location.longitude
    }

    convenience init (_ location: CLLocationCoordinate2D) {
        self.init()
        self.location = location
    }

    convenience init(_ location: List<Double>?) {
        self.init()
        if let location = location {
            locationModel = location
            if location.count == 2 {
                latitude = location[1]
                longitude = location[0]
            } else {
                latitude = 0
                longitude = 0
            }
        } else {
            locationModel = List<Double>()
        }
    }
}
