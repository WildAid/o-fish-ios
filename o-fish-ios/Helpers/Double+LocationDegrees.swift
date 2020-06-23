//
//  Double+LocationDegrees.swift
//  
//  Created on 6/17/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import  Foundation

enum Coordinate: String {
    case latitude = "Latitude"
    case longitude = "Longitude"
}

extension Double {

    func locationDegrees(_ coordinate: Coordinate) -> String {
        let minutes = 60
        let seconds = 3600
        var coordSeconds = abs(Int((self * Double(seconds)).rounded()))
        let coordDegrees = coordSeconds / seconds
        coordSeconds = coordSeconds % seconds
        let coordMinutes = coordSeconds / minutes
        coordSeconds %= minutes

        var sideOfTheWorld = ""
        switch coordinate {
        case .latitude: sideOfTheWorld = self >= 0 ? "N" : "S"
        case .longitude: sideOfTheWorld = self >= 0 ? "E" : "W"
        }

        return String(format: "%02d°%02d'%02d\"%@",
                      coordDegrees,
                      coordMinutes,
                      coordSeconds,
                      sideOfTheWorld
        )
    }
}
