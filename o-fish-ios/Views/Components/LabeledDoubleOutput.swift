//
//  LabeledDoubleOutput.swift
//
//  Created on 3/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LabeledDoubleOutput: View {
    var coordinate: Coordinate
    var value: Double

    var body: some View {
        VStack(spacing: .zero) {
            Text(LocalizedStringKey(coordinate.rawValue))
                .font(.caption1)
            Text(value.locationDegrees(self.coordinate))
                .font(.body)
        }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

struct LabeledDoubleOutput_Previews: PreviewProvider {
    static var previews: some View {
        LabeledDoubleOutput(coordinate: .latitude, value: 22.3763527237532)
    }
}
