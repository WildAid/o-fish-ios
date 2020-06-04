//
//  DisplayField.swift
//
//  Created on 04/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DisplayField: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            CaptionLabel(title: title)
            Text(value)
                .foregroundColor(.black)
            Divider()
        }
    }
}

struct DisplayField_Previews: PreviewProvider {
    static var previews: some View {
        DisplayField(title: "Title", value: "Value")
    }
}
