//
//  DeliveryViewModelTests.swift
//  
//  Created on 7/31/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class DeliveryViewModelTests: XCTestCase {
    
    var sut: DeliveryViewModel?
    
    override func setUpWithError() throws {
        sut = DeliveryViewModel()
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
        let date = NSDate()
        let location = "Sydney"
        let business = "Retail"
        let delivery = Delivery()
        delivery.date = date
        delivery.location = location
        delivery.business = business
        
        //when
        sut = DeliveryViewModel(delivery)
        
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    func testSaveDeliveryNotNil() {
        //given
        let date = NSDate()
        let location = "Sydney"
        let business = "Retail"
        let delivery = Delivery()
        delivery.date = date
        delivery.location = location
        delivery.business = business
        sut = DeliveryViewModel(delivery)
        
        //when
        let deliveryObj = sut?.save()
        
        //then
        XCTAssertEqual(deliveryObj?.date, date)
        XCTAssertEqual(deliveryObj?.location, location)
        XCTAssertEqual(deliveryObj?.business, business)
    }
    
    func testSaveDeliveryNil() {
        //given
        let delivery: Delivery? = nil
        sut = DeliveryViewModel(delivery)
        
        //when
        let deliveryObj = sut?.save()
        
        //then
        XCTAssertNotNil(deliveryObj)
    }
    
}
