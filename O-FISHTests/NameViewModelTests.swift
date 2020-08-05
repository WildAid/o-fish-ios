//
//  NameViewModelTests.swift
//  
//  Created on 7/30/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class NameViewModelTests: XCTestCase {
    
    var sut: NameViewModel?
    let firstName = "name"
    let lastName = "surname"
    
    
    override func setUpWithError() throws {
        let name = Name()
        name.first = firstName
        name.last = lastName
        sut = NameViewModel(name: name)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testFullName() {
        let fullName = sut?.fullName
        XCTAssert(fullName == "name surname", "Full name doesn't equal given name")
    }
    
    func testSave() {
        let savingModel = sut?.save()
        XCTAssert(savingModel?.first == firstName, "Name doesn't equal given firstName")
        XCTAssert(savingModel?.last == lastName, "Last name doesn't equal lastName")
    }
}

