//
//  View+NavigationStyle.swift
//
//  Created on 24/06/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

extension View {
    func stackNavigationView() -> some View {
        AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
    }
}
