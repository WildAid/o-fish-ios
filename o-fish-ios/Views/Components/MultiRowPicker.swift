//
//  MultiRowPicker.swift
//
//  Created on 06/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct MultiRowPicker: View {
    @Binding var selection: [String]
    @State var dataSources: [[String]]

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<self.dataSources.count) { index in

                    Picker("", selection: self.$selection[index]) {
                        ForEach(self.dataSources[index]) { option in
                            Text(option)
                        }
                    }
                            .labelsHidden()
                            .frame(maxWidth: geometry.size.width / CGFloat(self.dataSources.count))
                            .clipped()
                }

            }
        }
    }
}

struct MultiRowPicker_Previews: PreviewProvider {
    static var previews: some View {
        let selection = ["Selected"]
        let dataSource = [["Selected"]]

        return MultiRowPicker(selection: .constant(selection),
                              dataSources: dataSource)
    }
}
