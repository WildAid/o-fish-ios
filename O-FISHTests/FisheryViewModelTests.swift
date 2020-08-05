//
//  FisheryViewModelTests.swift
//  
//  Created on 8/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class FisheryViewModelTests: XCTestCase {
    
    var sut: FisheryViewModel?
    
    override func setUpWithError() throws {
        sut = FisheryViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSaveFisheryNotNil() {
        //given
        let name = "test name"
        let attachments = AttachmentsViewModel()
        sut?.name = name
        sut?.attachments = attachments
        
        //when
        let fishery = sut?.save()
        
        //then
        XCTAssertEqual(fishery?.name, name)
        XCTAssertNotNil(fishery?.attachments)
    }
    
    func testSaveFisheryNil() {
        //given
        let fishery: Fishery? = nil
        sut = FisheryViewModel(fishery)
        
        //when
        let fisheryIn = sut?.save()
        
        //then
        XCTAssertNotNil(fisheryIn)
    }
    
}
