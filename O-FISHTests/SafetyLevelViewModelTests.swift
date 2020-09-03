//
//  SafetyLevelViewModelTests.swift
//  
//  Created on 8/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class SafetyLevelViewModelTests: XCTestCase {
    
    var sut: SafetyLevelViewModel?
    
    override func setUpWithError() throws {
        sut = SafetyLevelViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSaveSafetyLeveleNotNil() {
        //given
        let level = SafetyLevelViewModel.LevelColor.amber
        let amberReason = "Reason"
        let attachments = AttachmentsViewModel()
        sut?.level = level
        sut?.reason = amberReason
        sut?.attachments = attachments
        
        //when
        let safetyLevel = sut?.save()
        
        //then
        XCTAssertEqual(safetyLevel?.level, level.rawValue)
        XCTAssertEqual(safetyLevel?.amberReason, amberReason)
        XCTAssertNotNil(safetyLevel?.attachments)
    }
    
    func testSaveSafetyLevelNil() {
        //given
        let level: SafetyLevel? = nil
        sut = SafetyLevelViewModel(level)
        
        //when
        let safetyLevel = sut?.save()
        
        //then
        XCTAssertNotNil(safetyLevel)
    }
    
}
