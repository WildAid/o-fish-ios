//
//  CatchViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class CatchViewModelTests: XCTestCase {
    
    var sut: CatchViewModel?
    
    override func setUpWithError() throws {
        sut = CatchViewModel()
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
        let fish = "fish"
        let number = 10
        let weight = 25.0
        let unit: CatchViewModel.UnitSpecification = .kilograms
        
        //when
        sut?.fish = fish
        sut?.number = number
        sut?.weight = weight
        sut?.unit = unit
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    func testWeightStringNotEmpty() {
        let weight = 25.0
        sut?.weight = weight
        
        let weightString = sut?.weightString
        
        XCTAssertEqual(weightString, "\(weight)")
    }
    
    func testWeightStringIsEmpty() {
        let weight = 0.0
        sut?.weight = weight
        
        let weightString = sut?.weightString
        
        XCTAssertEqual(weightString, "")
    }
    
    
    func testSaveCatchNotNill() {
        //given
        let fish = "fish"
        let number = 10
        let weight = 25.0
        let unit: CatchViewModel.UnitSpecification = .pound

        //when
        sut?.fish = fish
        sut?.number = number
        sut?.weight = weight
        sut?.unit = unit
        let catchFish = sut?.save()

        //then
        XCTAssertEqual(catchFish?.fish, fish)
        XCTAssertEqual(catchFish?.number, number)
        XCTAssertEqual(catchFish?.weight, weight)
        XCTAssertEqual(catchFish?.unit, unit.rawValue)
    }

    func testSaveVesselNil() {
        //given
        let catchFish: Catch? = nil
        sut = CatchViewModel(catchFish)

        //when
        let fish = sut?.save()

        //then
        XCTAssertNotNil(fish)
    }


    func testIsComplete() {
        //given
        let sut = CatchViewModel()
        sut.fish = "Some fish"

        // when
        sut.weight = 1
        sut.unit = .pound
        sut.number = 10

        //then
        XCTAssertTrue(sut.isComplete)

        // when
        sut.weight = 0
        sut.unit = .notSelected
        sut.number = 10

        //then
        XCTAssertTrue(sut.isComplete)

        // when
        sut.weight = 1
        sut.unit = .kilograms
        sut.number = 0

        //then
        XCTAssertTrue(sut.isComplete)
    }

    func testIsNotComplete() {
        //given
        let sut = CatchViewModel()

        //then
        XCTAssertFalse(sut.isComplete)

        // when
        sut.fish = "Some fish"
        sut.weight = 1
        sut.unit = .notSelected
        sut.number = 1

        // then
        XCTAssertFalse(sut.isComplete, "Unit is mandatory")

        // when
        sut.fish = ""
        sut.weight = 1
        sut.unit = .kilograms
        sut.number = 1

        // then
        XCTAssertFalse(sut.isComplete, "Fish type mandatory")
    }
    
    func testInitWithCatch() {
        //given
        let fish = "fish"
        let number = 10
        let weight = 25.0
        let unit: CatchViewModel.UnitSpecification = .pound
        let catchFish = Catch()
        catchFish.fish = fish
        catchFish.number = number
        catchFish.weight = weight
        catchFish.unit = unit.rawValue
        
        //when
        sut = CatchViewModel(catchFish)
        
        //then
        XCTAssertNotNil(sut)
    }
}
