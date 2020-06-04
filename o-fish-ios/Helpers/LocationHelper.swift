//
//  LocationHelper.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: ObservableObject {
    static private let locationManager = CLLocationManager()

    // Snapshot of the device location
    static var currentLocation: CLLocationCoordinate2D {
        guard let location = locationManager.location else {
            return Constants.DefaultLocation
        }

        return location.coordinate
    }

    required init() {
        Self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Self.locationManager.requestWhenInUseAuthorization()
    }
}
