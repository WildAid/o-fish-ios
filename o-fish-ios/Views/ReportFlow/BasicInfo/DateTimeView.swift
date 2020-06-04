//
//  DateTimeView.swift
//
//  Created on 04/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DateTimeView: View {
    @State var date: Date

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        HStack(spacing: Dimensions.spacing) {
            DisplayField(title: "Date", value: date.justDate())
            DisplayField(title: "Time", value: date.justTime())
        }
    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeView(date: Date())
    }
}
