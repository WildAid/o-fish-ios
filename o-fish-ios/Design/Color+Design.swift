//
//  Color+Design.swift
//
//  Created on 03/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import UIKit

extension UIColor {
    convenience init(red: UInt, green: UInt, blue: UInt, alpha: CGFloat = 1) {
        self.init(red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha)
    }

    public static let main = UIColor(red: 10, green: 64, blue: 116) // #0a4074
}

extension Color {
    init(red: UInt, green: UInt, blue: UInt, alpha: Double = 1) {
        self.init(red: Double(red) / 255.0,
                green: Double(green) / 255.0,
                blue: Double(blue) / 255.0,
                opacity: alpha)
    }
}

extension Color {
    public static let main = Color(.main)

    public static let backgroundGrey = Color(red: 249, green: 250, blue: 250) // f9fafa
    public static let text = Color.black

    public static let callToAction = main

    // gray
    public static let iconsGray = Color(white: 221.0/255.0) // #DDDDDD
    public static let captainGray = Color(white: 216.0/255.0)// #D8D8D8
    public static let removeAction = Color(white: 151.0/255.0)// #979797
    public static let inactiveBar = Color(white: 230.0/255.0)// #E6E6E6

    // green button
    public static let lilyWhite = Color(red: 236, green: 244, blue: 239) // #ECF4EF
    public static let darkSpringGreen = Color(red: 0, green: 133, blue: 55) // #008537

    // amber button
    public static let moonYellow = Color(red: 255, green: 191, blue: 34) //#FFBF22
    public static let oasis = Color(red: 255, green: 236, blue: 188, alpha: 0.3)
    public static let rowAmber = Color(red: 97, green: 69, blue: 0) //#614500
    public static let spanishOrange = Color(red: 255, green: 112, blue: 0) // #E17000

    // red button
    public static let persianRed = Color(red: 207, green: 34, blue: 34) //#CF2222
    public static let vanillaIce = Color(red: 246, green: 212, blue: 212, alpha: 0.3)
    public static let darkRed = Color(red: 150, green: 11, blue: 11) //#960B0B

    //status colors
    //green
    public static let bubbles = Color(red: 222, green: 239, blue: 229) //#DEEFE5
    public static let crusoe = Color(red: 0, green: 97, blue: 40)//#006128
    //red
    public static let faluRed = Color(red: 137, green: 21, blue: 21) //#891515

    public static let appGray = Color(white: 186.0/255.0)

}
