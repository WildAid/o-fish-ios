//
//  Offence.swift
//
//  Created on 13/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class Offence: EmbeddedObject {
    @objc dynamic var code = ""
    @objc dynamic var explanation = ""
}
