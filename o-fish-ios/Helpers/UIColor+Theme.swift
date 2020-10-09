//
//  UIColor+Theme.swift
//  
//  Created on 10/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit

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
    public static var lightThemeAmberLightest: UIColor {
        return UIColor(hex: "#FFF9EB")!
    }

    public static var lightThemeAmberLight: UIColor {
        return UIColor(hex: "#FFECBC")!
    }

    public static var lightThemeAmber: UIColor {
        return UIColor(hex: "#FFBF22")!
    }

    public static var darkThemeAmber: UIColor {
        return UIColor(hex: "#FFD575")!
    }

    public static var lightThemeAmberDarkest: UIColor {
        return UIColor(hex: "#614500")!
    }

    public static var lightThemeGreenLightest: UIColor {
        return UIColor(hex: "#EBF5EF")!
    }

    public static var lightThemeGreenLight: UIColor {
        return UIColor(hex: "#DEEFE5")!
    }

    public static var lightThemeGreen: UIColor {
        return UIColor(hex: "#00B34A")!
    }

    public static var darkThemeGreen: UIColor {
        return UIColor(hex: "#52D287")!
    }

    public static var lightThemeGreenDark: UIColor {
        return UIColor(hex: "#008537")!
    }

    public static var darkThemeGreenDark: UIColor {
        return UIColor(hex: "#00B34A")!
    }

    public static var lightThemeGreenDarkest: UIColor {
        return UIColor(hex: "#006128")!
    }

    public static var lightThemeRedLightest: UIColor {
        return UIColor(hex: "#FCF2F2")!
    }

    public static var lightThemeRedLight: UIColor {
        return UIColor(hex: "#F6D4D4")!
    }

    public static var lightThemeRed: UIColor {
        return UIColor(hex: "#DE3A2E")!
    }

    public static var darkThemeRed: UIColor {
        return UIColor(hex: "#FF6666")!
    }

    public static var lightThemeRedDark: UIColor {
        return UIColor(hex: "#CF2222")!
    }

    public static var darkThemeRedDark: UIColor {
        return UIColor(hex: "#CF2222")!
    }

    public static var lightThemeRedDarkest: UIColor {
        return UIColor(hex: "#891515")!
    }

    public static var lightThemeOrange: UIColor {
        return UIColor(hex: "#E17000")!
    }

    public static var darkThemeOrange: UIColor {
        return UIColor(hex: "#F19438")!
    }

    public static var lightThemeBlueLightest: UIColor {
        return UIColor(hex: "#E6EBF1")!
    }

    public static var darkThemeBlueLightest: UIColor {
        return UIColor(hex: "#E6EBF1")!
    }

    public static var lightThemeBlueLighter: UIColor {
        return UIColor(hex: "#C2CFDC")!
    }

    public static var lightThemeBlueLight: UIColor {
        return UIColor(hex: "#849FB9")!
    }

    public static var darkThemeBlueLight: UIColor {
        return UIColor(hex: "#C2CFDC")!
    }

    public static var lightThemeBlue: UIColor {
        return UIColor(hex: "#0A4074")!
    }

    public static var darkThemeBlue: UIColor {
        return UIColor(hex: "#3B78B6")!
    }

    public static var darkThemeBlueDark: UIColor {
        return UIColor(hex: "#1E3C5B")!
    }

    public static var darkThemeBlueDarkest: UIColor {
        return UIColor(hex: "#25323E")!
    }

    public static var themeBlack: UIColor {
        return UIColor(hex: "#000000")!
    }

    public static var darkThemeBlack2: UIColor {
        return UIColor(hex: "#1C1C1E")!
    }

    public static var darkThemeBlack3: UIColor {
        return UIColor(hex: "#2C2C2E")!
    }

    public static var darkThemeBlack4: UIColor {
        return UIColor(hex: "#38383A")!
    }

    public static var darkThemeBlack5: UIColor {
        return UIColor(hex: "#48484B")!
    }

    public static var themeWhite: UIColor {
        return UIColor(hex: "#FFFFFF")!
    }

    public static var lightThemeGrey1: UIColor {
        return UIColor(hex: "#666666")!
    }

    public static var darkThemeGrey1: UIColor {
        return UIColor(hex: "#979797")!
    }

    public static var lightThemeGrey2: UIColor {
        return UIColor(hex: "#818181")!
    }

    public static var darkThemeGrey2: UIColor {
        return UIColor(hex: "#CBCBCB")!
    }

    public static var lightThemeGrey3: UIColor {
        return UIColor(hex: "#979797")!
    }

    public static var darkThemeGrey3: UIColor {
        return UIColor(hex: "#DADADA")!
    }

    public static var lightThemeGrey4: UIColor {
        return UIColor(hex: "#B9B9B9")!
    }

    public static var lightThemeGrey5: UIColor {
        return UIColor(hex: "#CBCBCB")!
    }

    public static var lightThemeGrey6: UIColor {
        return UIColor(hex: "#DADADA")!
    }

    public static var lightThemeGrey7: UIColor {
        return UIColor(hex: "#E6E6E6")!
    }

    public static var lightThemeGrey8: UIColor {
        return UIColor(hex: "#F9FAFA")!
    }

    // MARK: - Semantic Colors
    public static var lightThemeBackgroundFill: UIColor {
        return self.themeWhite
    }

    public static var darkThemeBackgroundFill: UIColor {
        return self.darkThemeBlack2
    }

    public static var lightThemeText: UIColor {
        return self.black
    }

    public static var darkThemeFieldTitle: UIColor {
        return self.darkThemeGrey1
    }

    public static var darkThemeFieldValue: UIColor {
        return self.themeWhite
    }

    public static var darkThemeSectionFill: UIColor {
        return self.darkThemeBlack2
    }
}
