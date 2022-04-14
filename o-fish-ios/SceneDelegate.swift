//
//  SceneDelegate.swift
//
//  Created on 14/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Combine
import UIKit
import SwiftUI

typealias DisposeBag = [AnyCancellable]

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var disposeBag = DisposeBag()
    var window: UIWindow?
    var settings = Settings.shared
    var locationHelper = LocationHelper.shared
    var imageCache = ImageCache()
    private(set) static var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        Self.shared = self
        let rootView = MainNavigationRootView()

        if app.currentUser()?.state == .loggedIn {
            self.settings.realmUser = app.currentUser()
        }

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.actionBlue
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            window.tintColor = .oAccent

            window.rootViewController = UIHostingController(rootView: rootView
                .navigationBar(backgroundColor: .oNavbarBackground, textColor: .oText, tintColor: .oAccent)
                .stackNavigationView()
                .environmentObject(self.settings)
                .environmentObject(self.locationHelper)
                .environmentObject(self.imageCache)
                .onTapGesture {
                    // Hide the keyboard when clicking anywhere on the view
                    window.endEditing(true)
            })

            UserSettings.shared.$forceDarkMode.sink { [weak window] in
                window?.overrideUserInterfaceStyle = $0 ? .dark : .unspecified
            }.store(in: &self.disposeBag)
            updateAppearance()
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

    private func updateAppearance() {

        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.oText]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.oText]
        UINavigationBar.appearance().backgroundColor = .oNavbarBackground
        UINavigationBar.appearance().barTintColor = .oNavbarBackground
        UINavigationBar.appearance().tintColor = .oAccent
        UIWindow.appearance().tintColor = .oAccent
    }
}
