//
//  ViolationViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class ViolationViewModelTests: XCTestCase {
    
    var sut: ViolationViewModel?
    
    override func setUpWithError() throws {
        sut = ViolationViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testFullViolationDescription() {
        //given
        let offenceCode = "125"
        let offenceExplanation = "Explanation"
        let offenceLocation = "Location"
        let offenceModel = OffenceViewModel()
        offenceModel.code = offenceCode
        offenceModel.explanation = offenceExplanation
        offenceModel.location = offenceLocation
        sut?.offence = offenceModel
        
        //when
        let string = sut?.fullViolationDescription
        
        //then
        XCTAssertNotNil(string)
    }
    
    func testFullViolationDescriptionEmpty() {
        //given
        let offenceModel = OffenceViewModel()
        sut?.offence = offenceModel
        
        //when
        let string = sut?.fullViolationDescription
        
        //then
        XCTAssertEqual(string, "")
    }
    
    func testIsEmptyTrue() {
        let isEmpty = sut?.isEmpty ?? false
        XCTAssertTrue(isEmpty)
    }
    
    func testIsEmptyFalse() {
        //given
        let offenceCode = "125"
        let offenceExplanation = "Explanation"
        let offenceLocation = "Location"
        let offenceModel = OffenceViewModel()
        offenceModel.code = offenceCode
        offenceModel.explanation = offenceExplanation
        offenceModel.location = offenceLocation
        sut?.offence = offenceModel
        
        //when
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    func testSaveViolationNotNil() {
        //given
        sut?.disposition = .notSelected
        sut?.offence = OffenceViewModel()
        sut?.crewMember = CrewMemberViewModel()
        sut?.attachments = AttachmentsViewModel()
        
        //when
        let violation = sut?.save()
        
        //then
        XCTAssertNotNil(violation)
    }
    
    func testSaveViolationNil() {
        //given
        let violation: Violation? = nil
        sut = ViolationViewModel(violation)
        
        //when
        let violationIn = sut?.save()
        
        //then
        XCTAssertNotNil(violationIn)
    }
    
    func testInitViolationModelFromViolation() {
        //given
        let offence = Offence()
        let crewMember = CrewMember()
        let attachments = Attachments()
        let violation = Violation()
        violation.offence = offence
        violation.crewMember = crewMember
        violation.attachments = attachments
        
        //when
        sut = ViolationViewModel(violation)
        
        //then
        XCTAssertNotNil(sut)
    }
}
