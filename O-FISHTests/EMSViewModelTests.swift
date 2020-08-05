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
