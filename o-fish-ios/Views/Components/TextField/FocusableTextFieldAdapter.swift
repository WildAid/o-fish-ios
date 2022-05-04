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

    @Binding var text: String
    @State var becomeFirstResponder: Bool
    let tag: Int
    let placeholder: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let autocapitalizationType: UITextAutocapitalizationType
    let autocorrectionType: UITextAutocorrectionType
    private let textField = UITextField()

    func makeUIView(context: UIViewRepresentableContext<FocusableTextFieldAdapter>) -> UITextField {
        textField.tag = tag
        textField.delegate = context.coordinator
        textField.isSecureTextEntry = isSecure
        textField.placeholder = placeholder
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autocorrectionType
        textField.keyboardType = keyboardType

        textField.returnKeyType = .next
        textField.textColor = UIColor(Color.oText)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: context.coordinator,
                                                    action: #selector(Coordinator.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textField.inputAccessoryView = doneToolbar
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FocusableTextFieldAdapter>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.text = text
        if becomeFirstResponder == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                uiView.becomeFirstResponder()
                self.becomeFirstResponder = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text, textField)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var textField: UITextField

        init(_ text: Binding<String>, _ textField: UITextField) {
            self.text = text
            self.textField = textField
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

        @objc
        func doneButtonAction() {
            textField.resignFirstResponder()
        }

    }
}
