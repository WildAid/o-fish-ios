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
    @State private var isLoggedIn = RealmConnection.loggedIn

    var body: some View {
        NavigationView {
            if isLoggedIn {
                // TODO: Use the real user once the custom data is available from the Realm SDK
                PatrolBoatView(user: .sample, onDuty: DutyState(user: .sample), isLoggedIn: self.$isLoggedIn)
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
