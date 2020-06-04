//
//  View+Shadow.swift
//
//  Created on 03/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

extension View {

    @inlinable public func defaultShadow() -> some View {
        shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
    }

    @inlinable public func bottomShadow() -> some View {
        shadow(color: Color.black.opacity(0.17), radius: 15, x: 0, y: -12)
    }
}
