//
//  NoInputField.swift
//
//  Created on 15/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct NoInputField: View {
    var title = "Title"
    var text: String

    var body: some View {
        VStack {
            CaptionLabel(title: title)
            Text(text)
            Divider()
        }
    }
}

struct NoInputField_Previews: PreviewProvider {
    static var previews: some View {
        NoInputField(text: "Show text")
    }
}
