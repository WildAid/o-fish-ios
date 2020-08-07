//
//  EMSViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class EMSViewModelTests: XCTestCase {
    
    var sut: EMSViewModel?
    
    override func setUpWithError() throws {
        sut = EMSViewModel()
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
        let type = "radiolocative"
        let description = "description"
        let registryNumber = "1121"
        
        //when
        sut?.emsType = type
        sut?.emsDescription = description
        sut?.registryNumber = registryNumber
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    
    func testSaveEMSNotNil() {
        //given
        let type = "radiolocative"
        let description = "description"
        let registryNumber = "1121"
        let ems = EMS()
        ems.emsType = type
        ems.emsDescription = description
        ems.registryNumber = registryNumber
        sut = EMSViewModel(ems)
        
        //when
        let emsIn = sut?.save()
        
        //then
        XCTAssertEqual(emsIn?.emsType, type)
        XCTAssertEqual(emsIn?.emsDescription, description)
        XCTAssertEqual(emsIn?.registryNumber, registryNumber)
    }

    func testIsComplete() {
        //given
        let sut = EMSViewModel()

        // when
        sut.emsType = "Some type"
        sut.registryNumber = "12345789"

        //then
        XCTAssertTrue(sut.isComplete, "If name and licence is filled then crew should be complete")

        // when
        sut.emsType = "Other"
        sut.registryNumber = "12345789"
        sut.emsDescription = "Some description"

        //then
        XCTAssertTrue(sut.isComplete, "For other type should be an additional description")
    }

    func testIsNotComplete() {
        //given
        let sut = EMSViewModel()

        // when
        sut.emsType = ""
        sut.registryNumber = "12345789"

        //then
        XCTAssertFalse(sut.isComplete, "EMS type mandatory")

        // when
        sut.emsType = "Other"
        sut.registryNumber = "12345789"
        sut.emsDescription = ""

        //then
        XCTAssertFalse(sut.isComplete, "For Other type should be an additional description")

        // when
        sut.emsType = "Type"
        sut.registryNumber = ""

        //then
        XCTAssertFalse(sut.isComplete, "Registry number mandatory")
    }
    
    func testSaveEMSNil() {
        //given
        let ems: EMS? = nil
        sut = EMSViewModel(ems)
        
        //when
        let emsIn = sut?.save()
        
        //then
        XCTAssertNotNil(emsIn)
    }
    
}
