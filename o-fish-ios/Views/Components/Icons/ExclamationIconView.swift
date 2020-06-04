//
//  InputField.swift
//
//  Created on 15/05/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ExclamationIconView: View {

    var color = Color.spanishOrange
    var size: CGFloat = 20

    var body: some View {
        Image(systemName: "exclamationmark.circle.fill")
            .font(.system(size: size))
            .foregroundColor(color)
    }
}

struct ExclamationIconView_Previews: PreviewProvider {
    static var previews: some View {
        EditIconView()
    }
}
