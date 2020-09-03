//
//  RealmConnection.swift
//
//  Created on 19/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import RealmSwift

enum RealmConnectionError: String, Error {
    case cannotLogin = "Failed to log into Realm"
    case realmUserNotSet = "Realm user not set"
    case cannotCreateLocalRealm = "Cannot create local (synced) Realm"
}
