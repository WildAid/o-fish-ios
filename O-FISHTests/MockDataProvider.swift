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
    private let onAdd: ((ObjectBase, Realm.UpdatePolicy) -> Void)?
    private let onDelete: ((ObjectBase) -> Void)?
    private let onDeleteResults: ((Any) -> Void)?
    private let onObjects: ((Any.Type) -> Any)?
    private let onWrite: (([NotificationToken]) throws -> Void)?

    init(
        onAdd: ((ObjectBase, Realm.UpdatePolicy) -> Void)? = nil,
        onDelete: ((ObjectBase) -> Void)? = nil,
        onDeleteResults: ((Any) -> Void)? = nil,
        onObjects: ((Any.Type) -> Any)? = nil,
        onWrite: (([NotificationToken]) throws -> Void)? = nil) {

        self.onAdd = onAdd
        self.onDelete = onDelete
        self.onDeleteResults = onDeleteResults
        self.onObjects = onObjects
        self.onWrite = onWrite
    }

    func add(_ object: Object, update: Realm.UpdatePolicy) {
        if let onAdd = self.onAdd {
            onAdd(object, update)
        } else {
            XCTFail("Unexpected call of DataProvider.add(_:update:)")
        }
    }

    func delete(_ object: ObjectBase) {
        if let onDelete = self.onDelete {
            onDelete(object)
        } else {
            XCTFail("Unexpected call of DataProvider.delete(_:)")
        }
    }

    func delete<Element: ObjectBase>(_ objects: Results<Element>) {
        if let onDeleteResults = self.onDeleteResults {
            onDeleteResults(objects)
        } else {
            XCTFail("Unexpected call of DataProvider.delete(_:)")
        }
    }

    func objects<Element: Object>(_ elementType: Element.Type) -> Results<Element> {
        if let onObjects = self.onObjects {
            let result = onObjects(elementType)
            if let castedResult = result as? Results<Element> {
                return castedResult
            } else {
                XCTFail("Failed to cast \(type(of: result)) to \(Results<Element>.self)")
            }
        } else {
            XCTFail("Unexpected call of DataProvider.objects(_:)")
        }

        fatalError("Failed to return a value")
    }

    func write<Result>(withoutNotifying tokens: [NotificationToken], _ block: () throws -> Result) throws -> Result {
        if let onWrite = self.onWrite {
            try onWrite(tokens)
            return try block()
        } else {
            XCTFail("Unexpected call of DataProvider.write(withoutNotifying:_:)")
            throw MockError.unexpectedCall
        }
    }

    private enum MockError: Error {
        case unexpectedCall
    }
}
