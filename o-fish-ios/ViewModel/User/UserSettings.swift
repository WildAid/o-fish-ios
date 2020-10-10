//
//  UserSettings.swift
//  
//  Created on 10/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation
import Combine

private struct StringKeys {
    static let showDarkMode = "showDarkMode"
}

class UserSettings: ObservableObject {

    static let shared = UserSettings()

    @Published var showDarkMode: Bool {
        didSet {
            UserDefaults.standard.setValue(self.showDarkMode, forKey: StringKeys.showDarkMode)
            SceneDelegate.shared?.window?.overrideUserInterfaceStyle = (self.showDarkMode ? .dark : .light)
        }
    }

    init() {
        self.showDarkMode = (UserDefaults.standard.object(forKey: StringKeys.showDarkMode) as? Bool) ?? false
    }
}

extension UserDefaults {

    @objc dynamic var showDarkMode: Bool {
        return bool(forKey: StringKeys.showDarkMode)
    }
}
