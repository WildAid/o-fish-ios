//
//  LocationViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH
import CoreLocation
import RealmSwift

class LocationViewModelTests: XCTestCase {
    
    var sut: LocationViewModel?

    override func setUpWithError() throws {
        sut = LocationViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInitWithLocationAsCoordinate() {
        //given
        let location = CLLocationCoordinate2D(latitude: 51.506520923981554, longitude: -0.10689139236939127)
        
        //when
        sut = LocationViewModel(location)
        
        //then
        XCTAssertEqual(sut?.location.latitude, location.latitude)
        XCTAssertEqual(sut?.location.longitude, location.longitude)
    }
    
    func testInitWithLocationAsListSucces() {
        //given
        let location = List<Double>()
        location.append(51.506520923981554)
        location.append(-0.10689139236939127)
        
        //when
        sut = LocationViewModel(location)
        
        //then
        XCTAssertEqual(sut?.location.longitude, location[0])
        XCTAssertEqual(sut?.location.latitude, location[1])
    }
    
    func testInitWithLocationAsListFail() {
        //given
        let location = List<Double>()
        location.append(51.506520923981554)
        
        //when
        sut = LocationViewModel(location)
        
        //then
        XCTAssertNotNil(sut?.location.longitude)
        XCTAssertNotNil(sut?.location.latitude)
    }
    
    func testInitWithEmptyLocationList() {
        //given
        let location: List<Double>? = nil
        
        //when
        sut = LocationViewModel(location)
        
        //then
        XCTAssertNotNil(sut?.location.longitude)
        XCTAssertNotNil(sut?.location.latitude)
    }
}
