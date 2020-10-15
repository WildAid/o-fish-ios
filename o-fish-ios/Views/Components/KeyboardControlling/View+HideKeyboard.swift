//
//  View+HideKeyboard.swift
//  
//  Created on 10/14/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
