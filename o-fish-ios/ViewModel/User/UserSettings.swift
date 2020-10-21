//
//  UserSettings.swift
//  
//  Created on 10/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation
import Combine

private struct StringKeys {
    static let forceDarkMode = "forceDarkMode"
}

class UserSettings: ObservableObject {

    static let shared = UserSettings()

    @Published var forceDarkMode: Bool {
        didSet {
            UserDefaults.standard.setValue(self.forceDarkMode, forKey: StringKeys.forceDarkMode)
            SceneDelegate.shared?.window?.overrideUserInterfaceStyle = (self.forceDarkMode ? .dark : .light)
        }
    }

    init() {
        self.forceDarkMode = (UserDefaults.standard.object(forKey: StringKeys.forceDarkMode) as? Bool) ?? false
    }
}

extension UserDefaults {

    @objc dynamic var forceDarkMode: Bool {
        return bool(forKey: StringKeys.forceDarkMode)
    }
}
