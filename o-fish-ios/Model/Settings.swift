//
//  Settings.swift
//
//  Created on 19/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class Settings: ObservableObject {

    static let shared = Settings()

    var menuData = MenuData()

    var intialZoomLevel = 322000 // Meters to show in map views, ~= 200 mi

    var reuseDuration: TimeInterval = 10 //The duration for which Touch ID authentication reuse is allowable.

}
