//
//  AreaManager.swift
//  
//  Created on 6/15/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import CoreLocation

class AreaManager {
    static let shared = AreaManager()

    // TODO Remove after clarification method of parsing and storing coordinates for MPA borders
    func readJson(fileName: String) -> [[CLLocationCoordinate2D]]? {
        var polygonCoordinates: [[CLLocationCoordinate2D]]?
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let object = try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String: AnyObject]
            else {
                return nil
        }

        if let geometries = object["geometries"] as? [[String: AnyObject]],
            let objectCoordinates = geometries.first,
            let allCoordinates = objectCoordinates["coordinates"] as? [[[AnyObject]]] {
            polygonCoordinates = [[CLLocationCoordinate2D]]()
            for lineCoordinates in allCoordinates {
                var lineCoordinatesIn = [CLLocationCoordinate2D]()
                if let lineCoordinatesArray = lineCoordinates.first {
                    for coordinates in lineCoordinatesArray {

                        if let longitude = coordinates.firstObject as? Double,
                            let latitude = coordinates.lastObject as? Double {

                            let cLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            lineCoordinatesIn.append(cLLocationCoordinate2D)
                        }
                    }
                }
                if !lineCoordinatesIn.isEmpty {
                    polygonCoordinates?.append(lineCoordinatesIn)
                }
            }
        }

        return polygonCoordinates
    }
}
