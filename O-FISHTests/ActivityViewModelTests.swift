//
//  ActivityViewModelTests.swift
//  
//  Created on 8/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class ActivityViewModelTests: XCTestCase {
    
    var sut: ActivityViewModel?
    
    override func setUpWithError() throws {
        sut = ActivityViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSaveActivityNotNil() {
        //given
        let name = "test name"
        let attachments = AttachmentsViewModel()
        sut?.name = name
        sut?.attachments = attachments
        
        //when
        let activity = sut?.save()
        
        //then
        XCTAssertEqual(activity?.name, name)
        XCTAssertNotNil(activity?.attachments)
    }
    
    func testSaveActitivyNil() {
        //given
        let activity: Activity? = nil
        sut = ActivityViewModel(activity)
        
        //when
        let activityIn = sut?.save()
        
        //then
        XCTAssertNotNil(activityIn)
    }
}
