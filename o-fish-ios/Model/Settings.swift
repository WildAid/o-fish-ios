//
//  Settings.swift
//
//  Created on 19/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation
import RealmSwift

let app = App(id: Constants.realmAppId)

class Settings: ObservableObject {
    static let shared = Settings()

    @Published var realmUser: RealmSwift.User?
    var menuData = MenuData()

    var intialZoomLevel = 322000 // Meters to show in map views, ~= 200 mi

    var reuseDuration: TimeInterval = 10 //The duration for which Touch ID authentication reuse is allowable.
}

extension RealmSwift.User {
    var partition: String {
        guard case let .document(agency) = self.customData?["agency"],
              case let .string(partition) = agency["name"] else {
                print("Partition not set")
                return ""
        }

        return partition
    }

    func agencyRealm() -> Realm? {
        try? Realm(configuration: self.configuration(partitionValue: partition))
    }

    var firstName: String {
        guard case let .document(name) = self.customData?["name"],
              case let .string(first) = name["first"] else {
                print("First name not set")
                return "John"
        }
        return first
    }

    var lastName: String {
        guard case let .document(name) = self.customData?["name"],
            case let .string(last) = name["last"] else {
                print("Last name not set")
                return "Doe"
        }
        return last
    }

    var emailAddress: String {
        guard case let .string(email) = self.customData?["email"] else {
            print("email not set")
            return "john.doe@wildaid.org"
        }
        return email
    }

    var profilePictureDocumentId: String? {
        guard case let .string(profilePic) = self.customData?["profilePic"] else {
            return nil
        }
        return profilePic
    }
}
