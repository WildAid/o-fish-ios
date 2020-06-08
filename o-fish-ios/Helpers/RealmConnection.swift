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

class RealmConnection {
    static var realm: Realm?
    static var user = app.currentUser()

    static var loggedIn: Bool {
        return app.currentUser() != nil
    }
    static var isConnected: Bool { realm != nil }

    static var partition: String {
        guard let user = user else {
            print("User not set")
            return ""
        }
        guard case let .document(agency) = user.customData?["agency"],
              case let .string(partition) = agency["name"] else {
                print("Partition not set")
                return ""
        }
        return partition
    }

    static var firstName: String {
        guard let user = user else {
            print("User not set")
            return "John"
        }
        guard case let .document(name) = user.customData?["name"],
              case let .string(first) = name["first"] else {
                print("First name not set")
                return "John"
        }
        return first
    }

    static var lastName: String {
        guard let user = user else {
            print("User not set")
            return "Doe"
        }
        guard case let .document(name) = user.customData?["name"],
            case let .string(last) = name["last"] else {
                print("Last name not set")
                return "Doe"
        }
        return last
    }

    static var emailAddress: String {
        guard let user = user else {
            print("User not set")
            return "Doe"
        }
        guard case let .string(email) = user.customData?["email"] else {
            print("email not set")
            return "john.doe@wildaid.org"
        }
        return email
    }

    private static let app = RealmApp(id: Constants.realmAppId)

    static func logIn(username: String,
                      password: String,
                      completion: @escaping (Result<String, Error>) -> Void) {
        print("Request to Realm login as user: \(username.lowercased())")
        if loggedIn {
            print("Already logged in")
            completion(.success("User already logged in"))
        } else {
            let appCredentials = AppCredentials(username: username.lowercased(), password: password)
            app.login(withCredential: appCredentials) { (user, error) in
                if let error = error {
                    self.user = nil
                    print("\(RealmConnectionError.cannotLogin.localizedDescription) : \(error.localizedDescription)")
                    completion(.failure(RealmConnectionError.cannotLogin))
                    return
                }
                self.user = user
                print("Logged into Realm")
                completion(.success("Logged into Realm"))
            }
        }
    }

    static func connect() {
        if realm != nil {
            print("realm already set")
            return
        }

        guard let user = user else {
            print("User not set")
            return
        }

        guard let realm = try? Realm(configuration: user.configuration(partitionValue: partition)) else {
            print("Cannot connect to local Realm")
            return
        }
        self.realm = realm
        print("Connected to realm")
    }

    static func logout() {
        app.logOut { error in
            if let error = error {
                print("Failed to logout of Realm: \(error.localizedDescription)")
            } else {
                user = nil
                realm = nil
            }
        }
    }

    static func safeWrite(_ object: Object?, assign: () -> Void) {
        if object != nil {
            do {
                guard let realm = realm else {
                    print("Could not get local Realm")
                    return
                }
                try realm.write {
                    assign()
                }
            } catch {
                print("Unable to write value to Realm")
            }
        }
    }
}
