//
//  DataProvider.swift
//
//  Created by Eugene Berdnikov on 28/10/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

protocol DataProvider {
    func delete(_ object: ObjectBase)
}

extension Realm: DataProvider {
}
