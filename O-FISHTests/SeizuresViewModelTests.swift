//
//  SeizuresViewModelTests.swift
//  
//  Created on 8/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class SeizuresViewModelTests: XCTestCase {
    
    var sut: SeizuresViewModel?
    
    override func setUpWithError() throws {
        sut = SeizuresViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSaveSeizuresNotNil() {
        //given
        let description = "Test description"
        let attachments = AttachmentsViewModel()
        sut?.description = description
        sut?.attachments = attachments
        
        //when
        let seizures = sut?.save()
        
        //then
        XCTAssertEqual(seizures?.text, description)
        XCTAssertNotNil(seizures?.attachments)
    }
    
    func testSaveSeizuresNil() {
        //given
        let seizures: Seizures? = nil
        sut = SeizuresViewModel(seizures)
        
        //when
        let seizuresIn = sut?.save()
        
        //then
        XCTAssertNotNil(seizuresIn)
    }
    
}
