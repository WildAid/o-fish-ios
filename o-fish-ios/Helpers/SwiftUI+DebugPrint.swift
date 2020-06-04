//
//  SwiftUI+DebugPrint.swift
//
//  Created on 26/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

func debugPrint(_ vars: Any...) -> some View {
    for some in vars {
        print(some)
    }
    return EmptyView()
}
