//
//  DataProvider.swift
//
//  Created by Eugene Berdnikov on 28/10/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

protocol DataProvider {
    func add(_ object: Object, update: Realm.UpdatePolicy)
    func delete(_ object: ObjectBase)
    func delete<Element: ObjectBase>(_ objects: Results<Element>)
    func objects<Element: Object>(_ type: Element.Type) -> Results<Element>
    func write<Result>(withoutNotifying tokens: [NotificationToken], _ block: () throws -> Result) throws -> Result
}

extension DataProvider {
    func add(_ object: Object) {
        self.add(object, update: .error)
    }

    func write<Result>(_ block: () throws -> Result) throws -> Result {
        try self.write(withoutNotifying: [], block)
    }
}

extension Realm: DataProvider {
}
