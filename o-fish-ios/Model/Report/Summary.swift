//
//  Summary.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Summary: EmbeddedObject {
    @objc dynamic var safetyLevel: SafetyLevel? = SafetyLevel()
    let violations = List<Violation>()
    @objc dynamic var seizures: Seizures? = Seizures()
}
