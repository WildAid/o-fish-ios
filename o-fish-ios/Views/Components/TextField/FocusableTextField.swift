//
//  FocusableTextField.swift
//
//  Created on 18.10.2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit

/// UITextField is used by SwiftUI 'FocusableTextFieldAdapter'
final class FocusableTextField: UITextField {
    var onEditingHandler: ((String) -> Void)?
}

extension FocusableTextField: UITextFieldDelegate {

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
        onEditingHandler?(textField.text ?? "")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentValue = textField.text as NSString? {
            let proposedValue = currentValue.replacingCharacters(in: range, with: string)
            onEditingHandler?(proposedValue)
        }
        return true
    }
}
