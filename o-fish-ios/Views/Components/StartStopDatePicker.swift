//
//  StartStopDatePicker.swift
//
//  Created on 2/06/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct StartStopDatePicker: View {

    let title: String
    @Binding var startDate: Date
    @Binding var endDate: Date

    var spacing: CGFloat = 16
    var bottomPadding: CGFloat = 24

    var body: some View {
        VStack(spacing: spacing) {
            TitleLabel(title: title)
                .padding(.top, spacing)

            editableDateComponent(title: "Start Time", date: startDate, action: startDateClicked)
            editableDateComponent(title: "End Time", date: endDate, action: endDateClicked)
                .padding(.bottom, bottomPadding)
        }
    }

    private func editableDateComponent(title: String, date: Date, action: @escaping () -> Void) -> some View {
        ZStack(alignment: .trailing) {
            ButtonField(title: title, text: date.fullDateTime(), fieldButtonClicked: action)
            Button(action: action) {
                EditIconView(topPadding: 0)
            }
        }
    }

    /// Actions

    func startDateClicked() {
        showDateEditor(date: startDate, to: endDate) { newDate in
            self.startDate = newDate
        }
    }

    func endDateClicked() {
        showDateEditor(date: endDate, from: startDate) { newDate in
            self.endDate = newDate
        }
    }

    /// Logic

    func showDateEditor(date: Date,
                        from: Date = .distantPast,
                        to: Date = .distantFuture,
                        completion: @escaping (Date) -> Void) {

        let popoverId = UUID().uuidString

        let datePickerSelectClicked = { (newDate: Date) in
            completion(newDate)
            PopoverManager.shared.hidePopover(id: popoverId)
        }

        PopoverManager.shared.showPopover(id: popoverId) {
            DatePickerWithButton(date: date,
                from: from,
                to: to,
                selectButtonClicked: datePickerSelectClicked)
                .background(Color.white)
        }
    }
}

struct StartStopDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        StartStopDatePicker(title: "Start and end time", startDate: .constant(Date()), endDate: .constant(Date()))
    }
}
