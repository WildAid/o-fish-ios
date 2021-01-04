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
        XCTAssertNotNil(sut)
        guard let sut = sut else {
            return
        }

        var writeCall = 0
        let addExpectation = self.expectation(description: "DataProvider.add")
        let deleteExpectation = self.expectation(description: "DataProvider.delete")
        let writeExpectation = self.expectation(description: "DataProvider.write")
        writeExpectation.expectedFulfillmentCount = 3
        let dataProvider = MockDataProvider(
            onAdd: { object, update in
                addExpectation.fulfill()
                XCTAssert(object is Report)
                XCTAssertEqual(update, .error)
            },
            onDelete: { object in
                deleteExpectation.fulfill()
                XCTAssert(object is Report)
            },
            onWrite: { tokens in
                writeCall += 1
                writeExpectation.fulfill()
                XCTAssertEqual(tokens, [])
                if writeCall == 2 {
                    throw TestError()
                }
            })
        sut.save(dataProvider)
        XCTAssertNotNil(sut.report)
        sut.discard(dataProvider)
        XCTAssertNil(sut.report)
        self.waitForExpectations(timeout: 0.1)
    }

    private struct TestError: Error {
    }
}
