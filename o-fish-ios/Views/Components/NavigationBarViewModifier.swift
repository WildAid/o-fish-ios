//
//  NavigationBarViewModifier.swift
//
//  Created on 19/06/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit
import SwiftUI

struct NavigationBarViewModifier: ViewModifier {

    let backgroundColor: UIColor
    let textColor: UIColor
    let tintColor: UIColor

    init(backgroundColor: UIColor, textColor: UIColor, tintColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.tintColor = tintColor

        let appearance = UINavigationBarAppearance(idiom: .phone)
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: textColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: textColor]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = tintColor
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationBar(backgroundColor: UIColor = .clear,
                       textColor: UIColor = .black,
                       tintColor: UIColor = .black) -> some View {

        self.modifier(NavigationBarViewModifier(backgroundColor: backgroundColor,
            textColor: textColor,
            tintColor: tintColor))
    }
}
