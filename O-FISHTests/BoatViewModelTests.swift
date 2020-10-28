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
    
    func testSaveVesselNil() {
        //given
        let boat: Boat? = nil
        sut = BoatViewModel(boat)

        //when
        let vessel = sut?.save(MockDataProvider())
        
        //then
        XCTAssertNotNil(vessel)
    }
}
