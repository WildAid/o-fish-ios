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
}

extension Color {
    init(red: UInt, green: UInt, blue: UInt, alpha: Double = 1) {
        self.init(red: Double(red) / 255.0,
                green: Double(green) / 255.0,
                blue: Double(blue) / 255.0,
                opacity: alpha)
    }
}
