//
//  OffenceViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class OffenceViewModelTests: XCTestCase {
    
    var sut: OffenceViewModel?
      

    override func setUpWithError() throws {
        let location = "California"
        let offence = Offence()
        sut = OffenceViewModel(offence)
        sut?.location = location
    }

    override func tearDownWithError() throws {
       sut = nil
    }
    
    func testOffenceIsEmptyTrue() {
        // given
        let code = "125"
        let explanation = "Invalid license"
        sut?.code = code
        sut?.explanation = explanation
        
        //when
        let isEmpty = sut?.isEmpty ?? false
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    func testOffenceIsEmptyFalse() {
        //when
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertTrue(isEmpty)
    }

    func testSaveWithOffence() {
        //given
        let code = "125"
        let explanation = "Invalid license"
        let offence = Offence()
        offence.code = code
        offence.explanation = explanation
        sut = OffenceViewModel(offence)
        
        //when
        let offenceSaving = sut?.save()
        
        //then
        XCTAssert(offenceSaving?.code == code)
        XCTAssert(offenceSaving?.explanation == explanation)
    }
    
    func testWithoutOffence() {
        // given
        sut = OffenceViewModel()
        
        //when
        let offenceSaving = sut?.save()
        
        //then
        XCTAssertNotNil(offenceSaving)
    }
}
