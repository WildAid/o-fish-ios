//
//  LocationViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import MapKit

class LocationViewModel: ObservableObject, Identifiable {
    private var locationModel: Location?

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

    convenience init(_ location: Location?) {
        self.init()
        if let location = location {
            locationModel = location
            latitude = location.latitude
            longitude = location.longitude
        } else {
            locationModel = Location()
        }
    }

    func save() -> Location? {
        let isNew = (locationModel == nil)
        if isNew {
            locationModel = Location()
        }
        guard let locationModel = locationModel else { return nil }
        locationModel.latitude = latitude
        locationModel.longitude = longitude
        return locationModel
    }
}
