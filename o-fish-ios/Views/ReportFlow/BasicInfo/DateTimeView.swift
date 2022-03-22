//
//  DateTimeView.swift
//
//  Created on 04/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DateTimeView: View {
    @Binding var date: Date

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        HStack(spacing: Dimensions.spacing) {
            ButtonField(title: "Date",
                        text: date.justDate(),
                        fieldButtonClicked: {
                            self.dateFieldClicked(type: .date)
            })

            ButtonField(title: "Time",
                        text: date.justTime(),
                        fieldButtonClicked: {
                            self.dateFieldClicked(type: .time)
            })
        }
    }

    private func dateFieldClicked(type: UIDatePicker.Mode) {
        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available

        let popoverId = UUID().uuidString

        let datePickerSelectClicked = { (date: Date) in
            self.newDate(from: date, type: type)
            PopoverManager.shared.hidePopover(id: popoverId)
        }

        PopoverManager.shared.showPopover(id: popoverId, content: {
            DatePickerView(date: date, mode: type, completion: datePickerSelectClicked)
        }, withButton: false)
    }

    private func newDate(from date: Date, type: UIDatePicker.Mode) {
        var dateComponentsOutDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: self.date)
        let dateComponentsDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: date)

        switch type {
        case .date:
            dateComponentsOutDate.year = dateComponentsDate.year
            dateComponentsOutDate.month = dateComponentsDate.month
            dateComponentsOutDate.day = dateComponentsDate.day
        case .time:
            dateComponentsOutDate.hour = dateComponentsDate.hour
            dateComponentsOutDate.minute = dateComponentsDate.minute
        default:
            return
        }

        self.date = Calendar.current.date(from: dateComponentsOutDate) ?? Date()
    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeView(date: .constant(Date()))
    }
}
