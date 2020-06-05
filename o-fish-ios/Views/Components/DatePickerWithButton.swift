//
//  DatePickerWithButton.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DatePickerWithButton: View {

    var selectButtonTitle: String = "Select"
    @State private var date = Date()

    var selectButtonClicked: ((Date) -> Void)

    var body: some View {
        VStack {
            Button(action: { self.selectButtonClicked(self.date) }) {
                HStack {
                    Text(selectButtonTitle)
                }
            }
            DatePicker("", selection: $date, in: ...Date())
                .labelsHidden()
        }
    }
}

struct DatePickerWithButton_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerWithButton {_ in}
    }
}
