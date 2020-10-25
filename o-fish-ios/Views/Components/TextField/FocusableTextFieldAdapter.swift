//
//  FocusableTextFieldAdapter.swift
//
//  Created on 18.10.2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

/// UITextField adapter to use in SwiftUI.
/// It's needed while interested behavior (can be expanded) isn't availble in SwiftUI. Such as:
/// 1. Setting returnKeyType
/// 2. After 'Return key' tap move focus to the next screen textField
struct FocusableTextFieldAdapter: UIViewRepresentable {

    private let tag: Int
    private let text: String
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let autocapitalizationType: UITextAutocapitalizationType
    private let onEditingHandler: ((String) -> Void)?
    private let textField = FocusableTextField()

    init(
        tag: Int,
        text: String,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType,
        autocapitalizationType: UITextAutocapitalizationType,
        onEditingHandler: ((String) -> Void)?) {
        self.tag = tag
        self.text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.onEditingHandler = onEditingHandler
    }

    func makeUIView(context: UIViewRepresentableContext<FocusableTextFieldAdapter>) -> FocusableTextField {
        textField.tag = tag
        textField.text = text
        textField.delegate = textField
        textField.onEditingHandler = onEditingHandler
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = autocapitalizationType
        textField.keyboardType = keyboardType

        textField.returnKeyType = .next
        textField.textColor = UIColor(Color.text)
        textField.font = UIFont.preferredFont(forTextStyle: .body)

        return textField
    }

    func updateUIView(_ uiView: FocusableTextField, context: UIViewRepresentableContext<FocusableTextFieldAdapter>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
