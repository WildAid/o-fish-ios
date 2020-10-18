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
}

extension Color {

    // MARK: - Named Colors
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

    public static var oText: Color {
        return Color("oText")
    }
}
