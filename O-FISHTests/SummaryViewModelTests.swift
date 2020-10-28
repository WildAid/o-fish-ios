//
//  SummaryViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class SummaryViewModelTests: XCTestCase {
    
    var sut: SummaryViewModel?
    
    override func setUpWithError() throws {
        sut = SummaryViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSaveSummaryNotNil() {
        
        //given
        let safetyLevel = SafetyLevelViewModel()
        let violations = [ViolationViewModel()]
        let seizures = SeizuresViewModel()
        
        sut?.safetyLevel = safetyLevel
        sut?.violations = violations
        sut?.seizures = seizures
        
        //when
        let summary = sut?.save(MockDataProvider())
        
        //then
        XCTAssertNotNil(summary)
    }
    
    func testSaveSummaryNil() {
        //given
        let summary: Summary? = nil
        sut = SummaryViewModel(summary)
        
        //when
        let summaryIn = sut?.save(MockDataProvider())
        
        //then
        XCTAssertNotNil(summaryIn)
    }
}
