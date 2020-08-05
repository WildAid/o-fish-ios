//
//  AttachmentsViewModelTests.swift
//  
//  Created on 8/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class AttachmentsViewModelTests: XCTestCase {
    
    var sut: AttachmentsViewModel?
    
    override func setUpWithError() throws {
        sut = AttachmentsViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSaveAttachmentsNotNil() {
        //given
        let notes = [ Note(text: "Note1"), Note(text: "Note2")]
        let photoIDs = ["photoID1", "phototID2"]
        sut?.notes = notes
        sut?.photoIDs = photoIDs
        
        //when
        let attachments = sut?.save()
        
        //then
        XCTAssertNotNil(attachments?.notes)
        XCTAssertNotNil(attachments?.photoIDs)
    }
    
    func testSaveAttachmentsNil() {
        //given
        let attachments: Attachments? = nil
        sut = AttachmentsViewModel(attachments)
        
        //when
        let attachmentsIn = sut?.save()
        
        //then
        XCTAssertNotNil(attachmentsIn)
    }
}
