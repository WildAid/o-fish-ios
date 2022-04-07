//
//  UIColor+Theme.swift
//  
//  Created on 10/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {

    public convenience init?(hex: String) {
        let red, green, blue, alpha: CGFloat
        let start: String.Index

        if hex.hasPrefix("#") {
            start = hex.index(hex.startIndex, offsetBy: 1)
        } else {
            start = hex.startIndex
        }

        let hexColor = String(hex[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            if hexColor.count == 8 {
                red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                alpha = CGFloat(hexNumber & 0x000000ff) / 255
            } else if hexColor.count == 6 {
                red = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                green = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                blue = CGFloat(hexNumber & 0x000000ff) / 255
                alpha = 1.0
            } else {
                red = 1.0
                green = 1.0
                blue = 1.0
                alpha = 1.0
            }

            self.init(red: red, green: green, blue: blue, alpha: alpha)
            return
        }

        return nil
    }

    // MARK: - Named Colors
    public static var main: UIColor {
        return UIColor(named: "main")!
    }

    public static var actionBlue: UIColor {
        return UIColor(named: "actionBlue")!
    }

    public static var oBlue: UIColor {
        return UIColor(named: "oBlue")!
    }

    // MARK: - Semantic Colors
    public static var oAccent: UIColor {
        return self.oBlue
    }

    public static var oAltBackground: UIColor {
        return UIColor(named: "oAltBackground")!
    }

    public static var oBackground: UIColor {
        return UIColor(named: "oBackground")!
    }

    public static var oNavbarBackground: UIColor {
        return self.oAltBackground
    }

    public static var oText: UIColor {
        return UIColor(named: "oText")!
    }

    public static var inactiveBar: UIColor {
        return UIColor(named: "oInactiveBar")!
    }

    public static var oSearchBar: UIColor {
        return UIColor(named: "oSearchBar")!
    }
}

extension Color {

    // MARK: - Named Colors
    public static var main: Color {
        return Color("main")
    }

    public static var oAmber: Color {
        return Color("oAmber")
    }

    public static var oBlue: Color {
        return Color("oBlue")
    }

    public static var oGreen: Color {
        return Color("oGreen")
    }

    public static var oGreenDark: Color {
        return Color("oGreenDark")
    }

    public static var oRed: Color {
        return Color("oRed")
    }

    public static var oRedDark: Color {
        return Color("oRedDark")
    }

    public static var oGray: Color {
        return Color("oGray")
    }

    // MARK: - Semantic Colors
    public static var oAccent: Color {
        return self.oBlue
    }

    public static var oAltBackground: Color {
        return Color("oAltBackground")
    }

    public static var oBackground: Color {
        return Color("oBackground")
    }

    public static var oButtonBackground: Color {
        return self.oBlue
    }

    public static var oDivider: Color {
        return Color("oDivider")
    }

    public static var oFieldTitle: Color {
        return Color("oFieldTitle")
    }

    public static var oFieldValue: Color {
        return self.oText
    }

    public static var oNavbarBackground: Color {
        return self.oAltBackground
    }

    public static var oSelectionBackground: Color {
        return Color("oSelectionBackground")
    }

    public static var oStrongOverlay: Color {
        return Color("oStrongOverlay")
    }

    public static var oWeakOverlay: Color {
        return Color("oWeakOverlay")
    }

    public static var oText: Color {
        return Color("oText")
    }

    public static var inactiveBar: Color {
        return Color("oInactiveBar")
    }

    public static var oSearchBar: Color {
        return Color("oSearchBar")
    }

    // MARK: - Single appearance colors
    public static var backgroundGrey: Color {
        return Color("backgroundGrey")
    }

    public static var iconsGray: Color {
        return Color("iconsGray")
    }

    public static var captainGray: Color {
        return Color("captainGray")
    }

    public static var removeAction: Color {
        return Color("removeAction")
    }

    public static var lilyWhite: Color {
        return Color("lilyWhite")
    }

    public static var darkSpringGreen: Color {
        return Color("darkSpringGreen")
    }

    public static var lightSpringGreen: Color {
        return Color("lightSpringGreen")
    }

    public static var moonYellow: Color {
        return Color("moonYellow")
    }

    public static var moonLightYellow: Color {
        return Color("moonLightYellow")
    }

    public static var oasis: Color {
        return Color("oasis")
    }

    public static var spanishOrange: Color {
        return Color("spanishOrange")
    }

    public static var persianRed: Color {
        return Color("persianRed")
    }

    public static var persianLightRed: Color {
        return Color("persianLightRed")
    }

    public static var vanillaIce: Color {
        return Color("vanillaIce")
    }

    public static var darkRed: Color {
        return Color("darkRed")
    }

    public static var bubbles: Color {
        return Color("bubbles")
    }

    public static var crusoe: Color {
        return Color("crusoe")
    }

    public static var rowAmber: Color {
        return Color("rowAmber")
    }

    public static var faluRed: Color {
        return Color("faluRed")
    }

    public static var appGray: Color {
        return Color("appGray")
    }

    public static var lightGrayButton: Color {
        return Color("lightGrayButton")
    }

    public static var blackWithOpacity: Color {
        return Color("blackWithOpacity")
    }

    public static var lightGrayIcon: Color {
        return Color("lightGrayIcon")
    }

    public static var iconGreen: Color {
        return Color("iconGreen")
    }

    public static var actionBlue: Color {
        return Color("actionBlue")
    }
}
