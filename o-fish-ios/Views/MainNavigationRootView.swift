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
    @EnvironmentObject var settings: Settings

    var body: some View {
        if settings.realmUser == nil && app.currentUser()?.state == .loggedIn {
            print("Using same user as when last running the app")
            settings.realmUser = app.currentUser()
        }
        return NavigationView {
            if settings.realmUser != nil {
                PatrolBoatView()
            } else {
                LoginView()
            }
        }
    }
}

struct MainNavigationRootView_Previews: PreviewProvider {
    static var settings = Settings()
    static var previews: some View {
        MainNavigationRootView()
            .environmentObject(settings)
    }
}
