//
//  RowView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct RowView: View {
    var title = ""
    var value = ""

    var body: some View {
        VStack {
            CaptionLabel(title: title)
            CaptionLabel(title: value, color: .black)
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(title: "Title",
                value: "Value")
    }
}
