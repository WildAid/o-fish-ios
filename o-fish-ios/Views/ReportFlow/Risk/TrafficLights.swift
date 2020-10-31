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
            TrafficLightButton(targetColor: .green, selectedColor: self.$color.animation())
            TrafficLightButton(targetColor: .amber, selectedColor: self.$color.animation())
            TrafficLightButton(targetColor: .red, selectedColor: self.$color.animation())
        }
    }
}

struct TrafficLights_Previews: PreviewProvider {
    private struct LivePreview: View {
        @State var color = SafetyLevelViewModel.LevelColor.green

        var body: some View {
            TrafficLights(color: self.$color)
        }
    }

    static var previews: some View {
        VStack {
            LivePreview()
            Divider()
            TrafficLights(color: .constant(.amber))
                .environment(\.locale, .init(identifier: "uk"))
            Divider()
            TrafficLights(color: .constant(.red))
        }
    }
}
