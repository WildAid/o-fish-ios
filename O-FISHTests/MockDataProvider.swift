//
//  MockDataProvider.swift
//
//  Created by Eugene Berdnikov on 28/10/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift
import XCTest
@testable import O_FISH

class MockDataProvider: DataProvider {
    private let onDelete: ((ObjectBase) -> Void)?

    init(onDelete: ((ObjectBase) -> Void)? = nil) {
        self.onDelete = onDelete
    }

    func delete(_ object: ObjectBase) {
        if let onDelete = self.onDelete {
            onDelete(object)
        } else {
            XCTFail("Unexpected call of DataProvider.delete(_:)")
        }
    }
}
