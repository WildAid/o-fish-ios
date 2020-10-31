//
//  UserSettings.swift
//  
//  Created on 10/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

private struct StringKeys {
    static let forceDarkMode = "forceDarkMode"
}

class UserSettings: ObservableObject {

    static let shared = UserSettings()

    @Published var forceDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(self.forceDarkMode, forKey: StringKeys.forceDarkMode)
        }
    }

    init() {
        self.forceDarkMode = UserDefaults.standard.bool(forKey: StringKeys.forceDarkMode)
    }
}
