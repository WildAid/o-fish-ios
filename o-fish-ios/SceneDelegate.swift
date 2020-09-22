//
//  SceneDelegate.swift
//
//  Created on 14/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var settings = Settings.shared
    var locationHelper = LocationHelper.shared
    var imageCache = ImageCache()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        let rootView = MainNavigationRootView()

        let mainColor = UIColor.main

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.actionBlue
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            window.tintColor = mainColor

            window.rootViewController = UIHostingController(rootView: rootView
                .navigationBar(backgroundColor: .white, textColor: .black, tintColor: mainColor)
                .stackNavigationView()
                .environmentObject(self.settings)
                .environmentObject(self.locationHelper)
                .environmentObject(self.imageCache)
                .onTapGesture {
                    // Hide the keyboard when clicking anywhere on the view
                    window.endEditing(true)
            })
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        NotificationManager.shared.removeNotificationWithIdentifier(NotificationManager.closingNotificationIdentifier)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        if DutyState.shared.onDuty && app.currentUser()?.state == .loggedIn {
            NotificationManager.shared.requestNotificationAfterClosing(hours: Constants.Notifications.hoursAfterClosing)
        }
    }

}
