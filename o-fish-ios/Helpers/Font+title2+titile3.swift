//
//  Font+title2+title3.swift
//  
//  Created on 6/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

extension Font {
    static let title2: Font = Font.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
    static let title3: Font = Font.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize)

    static let caption1: Font = Font.system(size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    static let caption2: Font = Font.system(size: UIFont.preferredFont(forTextStyle: .caption2).pointSize)
}
