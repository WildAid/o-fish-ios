//
//  KeyboardControllingScrollView.swift
//
//  Created on 21/05/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct KeyboardControllingScrollView<Content: View>: View {
    @ObservedObject var controller: KeyboardController

    private let content: () -> Content

    init(_ content: @escaping () -> Content, controller: KeyboardController = .sharedController) {
        self.content = content
        self.controller = controller
    }

    var body: some View {
        ScrollView {
            content()
            Spacer(minLength: controller.keyboardRect.size.height)
        }
    }
}
