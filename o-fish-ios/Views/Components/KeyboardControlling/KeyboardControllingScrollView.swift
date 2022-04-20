//
//  KeyboardControllingScrollView.swift
//
//  Created on 21/05/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct KeyboardControllingScrollView<Content: View>: View {
    @ObservedObject var controller: KeyboardController

    var enableHideGesture: Bool
    private let content: () -> Content

    init(enableHideGesture: Bool = false, _ content: @escaping () -> Content, controller: KeyboardController = .sharedController) {
        self.enableHideGesture = enableHideGesture
        self.content = content
        self.controller = controller
    }

    var body: some View {
        ScrollView {
            content()
            Spacer(minLength: controller.keyboardRect.size.height)
        }
        .highPriorityGesture(
            DragGesture().onChanged { _ in
                if enableHideGesture {
                    self.hideKeyboard()
                }
            }
        )
    }
}
