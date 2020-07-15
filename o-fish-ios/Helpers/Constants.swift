//
//  Constants.swift
//
//  Created on 19/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import CoreLocation

struct Constants {

    static let realmAppId = "your-realm-app-id"

    static let DefaultLocation = CLLocationCoordinate2D(latitude: 51.506520923981554, longitude: -0.10689139236939127)

    static let maximumImageSize = 3 * 1024 * 1024 // 3 MB

    enum Notifications {
        static let hoursAfterClosing = 4
        static let hoursAfterStarting = 10
    }
}
