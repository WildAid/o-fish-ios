//
//  DateTimeStackView.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DateTimeStackView: View {
    @State var date: Date

    var body: some View {
        VStack {
            TitleLabel(title: date.justLongDate())
            HStack {
                Text(date.justTime())
                    .font(.body)
                Spacer()
            }
        }
    }
}

struct DateTimeStackView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeStackView(date: Date())
    }
}
