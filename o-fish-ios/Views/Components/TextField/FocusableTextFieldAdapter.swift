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

    let tag: Int
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let autocapitalizationType: UITextAutocapitalizationType
    let autocorrectionType: UITextAutocorrectionType

    func makeUIView(context: UIViewRepresentableContext<FocusableTextFieldAdapter>) -> UITextField {
        let textField = UITextField()

        textField.tag = tag
        textField.delegate = context.coordinator
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autocorrectionType
        textField.keyboardType = keyboardType

        textField.returnKeyType = .next
        textField.textColor = UIColor(Color.text)
        textField.font = UIFont.preferredFont(forTextStyle: .body)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FocusableTextFieldAdapter>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>

        init(_ text: Binding<String>) {
            self.text = text
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            let nextFieldOfSuperview = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField
            let nextFieldOfSuperSuperview = textField.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField
            let nextFieldOfSuperSuperSuperview = textField.superview?.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField

            let nextField = nextFieldOfSuperview ?? nextFieldOfSuperSuperview ?? nextFieldOfSuperSuperSuperview

            if let nextField = nextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentValue = textField.text as NSString? {
                let proposedValue = currentValue.replacingCharacters(in: range, with: string)
                text.wrappedValue = proposedValue
            }
            return true
        }

    }
}
