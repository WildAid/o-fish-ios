//
//  AppStrings.swift
//  
//  Created on 10/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

struct AppStrings {

    struct General {
        static let camera = NSLocalizedString("general.action.camera")
        static let close = NSLocalizedString("general.action.close")
        static let edit = NSLocalizedString("general.action.edit")
        static let logOut = NSLocalizedString("general.action.logout")
        static let photoLibrary = NSLocalizedString("general.action.photoLibrary")
    }

    struct Profile {
        static let logoutAlertTitle = NSLocalizedString("profile.logout.alert.title")
        static let logoutAlertMessage = NSLocalizedString("profile.logout.alert.message")
        static let atSeaLabel = NSLocalizedString("profile.atSea.label")
        static let notAtSeaLabel = NSLocalizedString("profile.notAtSea.label")
        static let darkModeLabel = NSLocalizedString("profile.darkmode.label")
    }
}
