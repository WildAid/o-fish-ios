//
//  InspectionViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class InspectionViewModelTests: XCTestCase {
    
    var sut: InspectionViewModel?
    
    override func setUpWithError() throws {
        sut = InspectionViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func testSaveInspectionNotNil() {
        //given
        let activity = ActivityViewModel()
        let fishery = FisheryViewModel()
        let gearType = GearTypeViewModel()
        let actualCatch = [CatchViewModel()]
        let summary = SummaryViewModel()
        let attachments = AttachmentsViewModel()
        
        sut?.activity = activity
        sut?.fishery = fishery
        sut?.gearType = gearType
        sut?.actualCatch = actualCatch
        sut?.summary = summary
        sut?.attachments = attachments
        
        //when
        let inspection = sut?.save(MockDataProvider())
        
        //then
        XCTAssertNotNil(inspection)
    }
    
    func testSaveInspectionNil() {
        //given
        let inspection: Inspection? = nil
        sut = InspectionViewModel(inspection)
        
        //when
        let inspectionIn = sut?.save(MockDataProvider())
        
        //then
        XCTAssertNotNil(inspectionIn)
    }
    
    func testInitFromInspection() {
        //given
        let activity = Activity()
        let fishery = Fishery()
        let gearType = GearType()
        let summary = Summary()
        let attachments = Attachments()
        let inspection = Inspection()
        inspection.activity = activity
        inspection.fishery = fishery
        inspection.gearType = gearType
        inspection.summary = summary
        inspection.attachments = attachments
        
        //when
        sut = InspectionViewModel(inspection)
        
        //then
        XCTAssertNotNil(sut)
    }
    
}
