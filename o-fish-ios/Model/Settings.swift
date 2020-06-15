//
//  Settings.swift
//
//  Created on 19/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class Settings: ObservableObject {

    static let shared = Settings()

    let menuDataList = MenuDataList()
    var intialZoomLevel = 50000 // Meters to show in map views
}
