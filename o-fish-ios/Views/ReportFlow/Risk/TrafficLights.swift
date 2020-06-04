//
//  TrafficLights.swift
//
//  Created on 05/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct TrafficLights: View {
    @Binding var color: SafetyLevelViewModel.LevelColor

    private enum Dimensions {
        static let spacing: CGFloat = 8.0
    }

    var body: some View {
        HStack(spacing: Dimensions.spacing) {
            TrafficLightButton(targetColor: .green,
                               selectedColor: self.$color)

            TrafficLightButton(targetColor: .amber,
                               selectedColor: self.$color)

            TrafficLightButton(targetColor: .red,
                               selectedColor: self.$color)
        }
    }
}

struct TrafficLights_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TrafficLights(color: .constant(.green))
            Divider()
            TrafficLights(color: .constant(.amber))
            Divider()
            TrafficLights(color: .constant(.red))
        }
    }
}
