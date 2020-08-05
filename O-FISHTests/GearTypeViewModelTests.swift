//
//  GearTypeViewModelTests.swift
//  
//  Created on 8/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class GearTypeViewModelTests: XCTestCase {
    
       var sut: GearTypeViewModel?
       
       override func setUpWithError() throws {
           sut = GearTypeViewModel()
       }
       
       override func tearDownWithError() throws {
           sut = nil
       }
       
       func testSaveGearTypeNotNil() {
           //given
           let name = "test name"
           let attachments = AttachmentsViewModel()
           sut?.name = name
           sut?.attachments = attachments
           
           //when
           let gearType = sut?.save()
           
           //then
           XCTAssertEqual(gearType?.name, name)
           XCTAssertNotNil(gearType?.attachments)
       }
       
       func testSaveFisheryNil() {
           //given
           let gearType: GearType? = nil
           sut = GearTypeViewModel(gearType)
           
           //when
           let gearTypeIn = sut?.save()
           
           //then
           XCTAssertNotNil(gearTypeIn)
       }
  
}
