//
//  MainNavigationRootView.swift
//
//  Created on 20/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

// Only MainNavigationRootView should include a NavigationView, that NavigationView
// will embed all of the other views
struct MainNavigationRootView: View {
    @State private var isLoggedIn = (app.currentUser()?.state == .loggedIn)

    var body: some View {
        NavigationView {
            if isLoggedIn {
                PatrolBoatView(isLoggedIn: $isLoggedIn)
            } else {
                LoginView(loggedIn: self.$isLoggedIn)
            }
        }
    }
}

struct MainNavigationRootView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationRootView()
    }
}
