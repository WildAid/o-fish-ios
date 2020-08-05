//
//  BoatViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH
import RealmSwift

class BoatViewModelTests: XCTestCase {

     var sut: BoatViewModel?
      
      override func setUpWithError() throws {
          sut = BoatViewModel()
      }
      
      override func tearDownWithError() throws {
          sut = nil
      }
      
      func testIsEmptyTrue() {
          let isEmpty = sut?.isEmpty ?? false
          XCTAssertTrue(isEmpty)
      }
      
    func testIsEmptyFalse() {
        //given
        let name = "Vessel"
        let homePort = "Sydney"
        let nationality = "Australia"
        let permitNumber = "1245"
        
        //when
        sut?.name = name
        sut?.homePort = homePort
        sut?.nationality = nationality
        sut?.permitNumber = permitNumber
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    
    func testSaveVesselNotNil() {
        //given
        let name = "Vessel"
        let homePort = "Sydney"
        let nationality = "Australia"
        let permitNumber = "1245"
        let vessel = Boat()
        let emsList = List<EMS>()
        emsList.append(EMS())
        emsList.append(EMS())
        vessel.name = name
        vessel.homePort = homePort
        vessel.nationality = nationality
        vessel.permitNumber = permitNumber
        sut = BoatViewModel(vessel)
        sut?.ems.append(EMSViewModel.sample)
        sut?.ems.append(EMSViewModel.sample)
        
        //when
        let boat = sut?.save()
        
        //then
        XCTAssertEqual(boat?.name, name)
        XCTAssertEqual(boat?.homePort, homePort)
        XCTAssertEqual(boat?.nationality, nationality)
        XCTAssertEqual(boat?.permitNumber, permitNumber)
        XCTAssertEqual(boat?.ems.first?.emsType, EMSViewModel.sample.emsType)
        XCTAssertEqual(boat?.ems.first?.registryNumber, EMSViewModel.sample.registryNumber)
    }
    
    func testSaveVesselNil() {
        //given
        let boat: Boat? = nil
        sut = BoatViewModel(boat)
        
        //when
        let vessel = sut?.save()
        
        //then
        XCTAssertNotNil(vessel)
    }
}
