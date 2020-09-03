//
//  CrewMemberViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class CrewMemberViewModelTests: XCTestCase {
    
    var sut: CrewMemberViewModel?

    override func setUpWithError() throws {
        sut = CrewMemberViewModel()
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
        let name = "name"
        let license = "lisence"
        
        //when
        sut?.license = license
        sut?.name = name
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    func testInitWithCrewMember() {
        //given
        sut = nil
        let name = "name"
        let license = "lisence"
        let crewMember = CrewMember()
        crewMember.name = name
        crewMember.license = license
        
        //when
        sut = CrewMemberViewModel(crewMember)
        
        //then
        XCTAssertNotNil(sut)
    }
    
    func testInitWithCrewMemberModel() {
        //given
        sut = nil
        let name = "name"
        let license = "lisence"
        let crewMemberModel = CrewMemberViewModel()
        crewMemberModel.name = name
        crewMemberModel.license = license
        
        //when
        sut = CrewMemberViewModel(crewMemberModel)
        
        //then
        XCTAssertNotNil(sut)
    }
    
    func testSaveCrewNotNil() {
        //given
        let name = "name"
        let license = "lisence"
        let crewMember = CrewMember()
        crewMember.name = name
        crewMember.license = license
        sut = CrewMemberViewModel(crewMember)
        
        //when
        let crew = sut?.save()
        
        //then
        XCTAssertEqual(crew?.name, name)
        XCTAssertEqual(crew?.license, license)
    }

    func testIsComplete() {
        //given
        let sut = CrewMemberViewModel()

        // when
        sut.name = "Name"
        sut.license = "Licence number"

        //then
        XCTAssertTrue(sut.isComplete, "If name and license is filled then crew should be complete")
    }

    func testIsNotComplete() {
        //given
        let sut = CrewMemberViewModel()

        // when
        sut.name = "Name"
        sut.license = ""

        //then
        XCTAssertFalse(sut.isComplete, "Should not be complete if only name exists")

        sut.name = ""
        sut.license = "Licence"
        XCTAssertFalse(sut.isComplete, "Should not be complete if only license exists")

        sut.name = ""
        sut.license = ""
        XCTAssertFalse(sut.isComplete, "Should not be complete if no data")
    }

    func testSaveCrewNil() {
        //given
        let crewMember: CrewMember? = nil
        sut = CrewMemberViewModel(crewMember)
        
        //when
        let crew = sut?.save()
        
        //then
        XCTAssertNotNil(crew)
    }
    
    func testClone() {
        //given
        let name = "name"
        let license = "lisence"
        let crewMember = CrewMember()
        crewMember.name = name
        crewMember.license = license
        sut = CrewMemberViewModel(crewMember)
        
        //when
        let crew = sut?.clone()
        
        //then
        XCTAssertEqual(crew?.name, name)
        XCTAssertEqual(crew?.license, license)
        XCTAssertNotEqual(sut?.id, crew?.id)
    }
}
