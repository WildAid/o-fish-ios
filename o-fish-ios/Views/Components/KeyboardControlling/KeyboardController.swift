//
//  KeyboardController.swift
//
//  Created on 21/05/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

final class KeyboardController: ObservableObject {
    static let sharedController = KeyboardController()

    @Published private(set) var keyboardRect = CGRect()

    init() {
        addObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyBoardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(keyBoardDidHide(notification:)),
            name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc private func keyBoardWillShow(notification: Notification) {
        if let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardRect = rect
        }
    }

    @objc private func keyBoardDidHide(notification: Notification) {
        keyboardRect = CGRect()
    }
}
