//
//  UserViewModelTests.swift
//  
//  Created on 7/30/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class UserViewModelTests: XCTestCase {
    
    var sut: UserViewModel?
    let firstName = "name"
    let lastName = "surname"
    let email = "test@email.com"
    
    
    override func setUpWithError() throws {
        let name = Name()
        name.first = firstName
        name.last = lastName
        let user = User()
        user.email = email
        user.name = name
        sut = UserViewModel(user)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSave() {
        let savingModel = sut?.save()
        XCTAssert(savingModel?.name?.first == firstName, "Name doesn't equal given firstName")
        XCTAssert(savingModel?.name?.last == lastName, "Last name doesn't equal lastName")
        XCTAssert(savingModel?.email == email,"Email doesn't equal test email")
    }
}
