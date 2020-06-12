//
//  DatePickerWithButton.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DatePickerWithButton: View {
    var selectButtonTitle: String = "Select"
    var selectButtonClicked: ((Date) -> Void)?

    @State private var date = Date()

    var body: some View {
        VStack {
            RectangleButton(title: selectButtonTitle, action: { self.selectButtonClicked?(self.date) })
            DatePicker("", selection: $date, in: ...Date())
                .labelsHidden()
        }
    }
}

struct DatePickerWithButton_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerWithButton()
    }
}
