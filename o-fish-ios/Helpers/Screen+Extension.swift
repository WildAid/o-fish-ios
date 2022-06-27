//
//  Screen+Extension.swift
//  
//  Created on 27.06.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import UIKit

@objc
extension UIScreen {

    @nonobjc static let screenWidth5: CGFloat = 320.0
    @nonobjc static let screenHeight5: CGFloat = 568.0
    @nonobjc static let screenWidth6: CGFloat = 375.0
    @nonobjc static let screenHeight6: CGFloat = 667.0
    @nonobjc static let screenWidth6Plus: CGFloat = 414.0
    @nonobjc static let screenHeight6Plus: CGFloat = 736.0
    @nonobjc static let screenHeightX: CGFloat = 812.0
    //
    // Avoid buggy @objc static let in Swift extension of Obj-C class.
    // swiftlint:disable attributes
    static func ocScreenWidth5() -> CGFloat { return screenWidth5 }
    static func ocScreenHeight5() -> CGFloat { return screenHeight5 }
    static func ocScreenWidth6() -> CGFloat { return screenWidth6 }
    static func ocScreenHeight6() -> CGFloat { return screenHeight6 }
    static func ocScreenWidth6Plus() -> CGFloat { return screenWidth6Plus }
    static func ocScreenHeight6Plus() -> CGFloat { return screenHeight6Plus }
    static func ocScreenHeightX() -> CGFloat { return screenHeightX }
    // swiftlint:enable attributes

    // MARK: - Screen capability
    /// 320.0 width
    @nonobjc static var isWidthAtLeast5: Bool {
        let bounds = UIScreen.main.fixedCoordinateSpace.bounds
        return bounds.width >= UIScreen.screenWidth5
    }
    /// 375.0 width
    @nonobjc static var isWidthAtLeast6: Bool {
        let bounds = UIScreen.main.fixedCoordinateSpace.bounds
        return bounds.width >= UIScreen.screenWidth6
    }
    /// 414.0 width
    @nonobjc static var isWidthAtLeast6Plus: Bool {
        let bounds = UIScreen.main.fixedCoordinateSpace.bounds
        return bounds.width >= UIScreen.screenWidth6Plus
    }
    /// 568.0 height
    @nonobjc static var isAtLeast5: Bool {
        let bounds = UIScreen.main.fixedCoordinateSpace.bounds
        return bounds.height >= UIScreen.screenHeight5
    }
    /// 667.0 height
    @nonobjc static var isAtLeast6: Bool {
        let bounds = UIScreen.main.fixedCoordinateSpace.bounds
        return bounds.height >= UIScreen.screenHeight6
    }
    /// 736.0 height
    @nonobjc static var isAtLeast6Plus: Bool {
        let bounds = UIScreen.main.fixedCoordinateSpace.bounds
        return bounds.height >= UIScreen.screenHeight6Plus
    }
    /// 812.0 height
    @nonobjc static var isAtLeast10: Bool {
        let bounds = UIScreen.main.fixedCoordinateSpace.bounds
        return bounds.height >= UIScreen.screenHeightX
    }

}
