//
//  MultiRowPickerWithButton.swift
//
//  Created on 06/03/2020.
//

import SwiftUI

struct MultiRowPickerWithButton: View {
    @Binding var selection: [String]
    @State var dataSources: [[String]]

    @State var selectButtonTitle: String = "Select"
    let selectButtonClicked: () -> Void

    var body: some View {
        VStack {
            Button(action: selectButtonClicked) {
                HStack {
                    Text(selectButtonTitle)
                }
            }

            MultiRowPicker(selection: $selection, dataSources: dataSources)
        }
    }
}

struct MultiRowPickerWithButton_Previews: PreviewProvider {
    static var previews: some View {
        MultiRowPickerWithButton(selection: .constant(["Selected"]),
                                 dataSources: [["Selected"]],
                                 selectButtonClicked: {})
    }
}
