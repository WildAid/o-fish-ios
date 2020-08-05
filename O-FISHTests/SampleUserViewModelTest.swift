//
//  SampleUserViewModelTest.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class SampleUserViewModelTest: XCTestCase {

    
    func testNameViewModelSample() {
        let name = NameViewModel.sample
        XCTAssert(name.first == "Big")
        XCTAssert(name.last == "Fish")
    }
    
    func testUserViewModelSample() {
        let user = UserViewModel.sample
        XCTAssert(user.name.first == "Big")
        XCTAssert(user.name.last == "Fish")
        XCTAssert(user.email == "john.doe@wildaid.org")
    }
    
    func testDutyChangeViewModelSample() {
        let dutyChange = DutyChangeViewModel.sample
        XCTAssert(dutyChange.user.name.first == "Big")
        XCTAssert(dutyChange.user.name.last == "Fish")
        XCTAssert(dutyChange.user.email == "john.doe@wildaid.org")
    }
}
