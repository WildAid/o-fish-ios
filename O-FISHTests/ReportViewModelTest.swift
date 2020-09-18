//
//  ReportViewModelTest.swift
//  
//  Created on 18/09/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class ReportViewModelTest: XCTestCase {
    var sut: ReportViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = .sample
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testSaveDiscard() {
        sut!.save()
        XCTAssertNotNil(sut!.report)
        sut!.discard()
        XCTAssertNil(sut!.report)
    }
}
