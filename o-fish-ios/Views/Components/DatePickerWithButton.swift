//
//  DatePickerWithButton.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DatePickerWithButton: View {

    var selectButtonTitle: String = "Select"
    @Binding private(set) var date: Date?

    var selectButtonClicked: (() -> Void)?

    var body: some View {
        VStack {
            Button(action: { self.selectButtonClicked?() }) {
                HStack {
                    Text(selectButtonTitle)
                }
            }
            DatePicker("", selection: dateBinding, in: ...Date())
                .labelsHidden()
        }
    }

    private var dateBinding: Binding<Date> {
        Binding<Date>(
            get: {
                if let date = self.date {
                    return date
                } else {
                    return Date()
                }
        },
            set: {
                self.date = $0
        })
    }
}

struct DatePickerWithButton_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerWithButton(date: .constant(Date()))
    }
}
