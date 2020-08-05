//
//  AnnotatedNoteViewModelTests.swift
//  
//  Created on 8/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import XCTest
@testable import O_FISH

class AnnotatedNoteViewModelTests: XCTestCase {
    
    var sut: AnnotatedNoteViewModel?
    
    override func setUpWithError() throws {
        sut = AnnotatedNoteViewModel()
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
        let note = "Simple Note"
        let photoIDs = ["photoID1", "phototID2"]
        sut?.note = note
        sut?.photoIDs = photoIDs
        
        //when
        let isEmpty = sut?.isEmpty ?? true
        
        //then
        XCTAssertFalse(isEmpty)
    }
    
    func testSaveAnnotatedNoteNotNil() {
        //given
        let note = "Simple Note"
        let photoIDs = ["photoID1", "phototID2"]
        sut?.note = note
        sut?.photoIDs = photoIDs
        
        //when
        let annotatedNote = sut?.save()
        
        //then
        XCTAssertEqual(annotatedNote?.note, note)
        XCTAssertNotNil(annotatedNote?.photoIDs)
    }
    
    func testSaveAnnotatedNoteNil() {
        //given
        let annotatedNote: AnnotatedNote? = nil
        sut = AnnotatedNoteViewModel(annotatedNote)
        
        //when
        let note = sut?.save()
        
        //then
        XCTAssertNotNil(note)
    }
    
    func testInitAnnotatedNoteModelFromNote() {
        //given
        let note = "Simple Note"
        let annotatedNote = AnnotatedNote()
        annotatedNote.note = note
        
        //when
        sut = AnnotatedNoteViewModel(annotatedNote)
        
        //then
        XCTAssertEqual(sut?.note, note)
        XCTAssertNotNil(sut)
    }
}
