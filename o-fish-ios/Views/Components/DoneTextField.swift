//
//  DoneTextField.swift
//  
//  Created on 10/10/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit
import SwiftUI

struct DoneTextField: View, UIViewRepresentable {

    @Binding var text: String
    let keyboardType: UIKeyboardType
    var isSecureTextEntry: Bool = false

    func makeUIView(context: Context) -> DoneUITextField {
        let textField = DoneUITextField()
        textField.keyboardType = keyboardType
        textField.textBinding = $text
        textField.isSecureTextEntry = isSecureTextEntry
        return textField
    }

    func updateUIView(_ uiView: DoneUITextField, context: Context) { }
}

class DoneUITextField: UITextField {

    var textBinding: Binding<String>? {
        didSet {
            text = textBinding?.wrappedValue
        }
    }

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isTranslucent = false
        toolbar.backgroundColor = .white
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        ]
        return toolbar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.inputAccessoryView = toolbar
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }

}
