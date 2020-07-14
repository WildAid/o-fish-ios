//
//  DatePickerWithButton.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DatePickerWithButton: View {

    @State var date = Date()

    @State var from = Date.distantPast
    @State var to = Date.distantFuture

    var selectButtonTitle: String = "Select"
    var selectButtonClicked: ((Date) -> Void)?
    var type: PickerType = .fullDate

    enum PickerType {
        case fullDate, onlyDate, hourAndMinute
    }

    private var displayedComponents: DatePickerComponents {
        switch type {
        case .fullDate: return [.hourAndMinute, .date]
        case .onlyDate: return .date
        case .hourAndMinute: return .hourAndMinute
        }
    }

    var body: some View {
        VStack {
            RectangleButton(title: selectButtonTitle, action: { self.selectButtonClicked?(self.date) })
            DatePicker("", selection: $date, in: from...to, displayedComponents: displayedComponents)
                .labelsHidden()
        }
    }
}

struct DatePickerWithButton_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerWithButton()
    }
}
