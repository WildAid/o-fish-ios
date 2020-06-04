//
//  TrafficLightButton.swift
//
//  Created on 05/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

typealias ButtonColors = (activeTextColor: Color, activeBackgroundColor: Color, inactiveTextColor: Color, inActiveBackgroundColor: Color)

struct TrafficLightButton: View {

    var targetColor: SafetyLevelViewModel.LevelColor
    @Binding var selectedColor: SafetyLevelViewModel.LevelColor

    private var colors: ButtonColors {
        var colors: ButtonColors
        switch targetColor {
        case .green: colors = ButtonColors(.white, .darkSpringGreen, .darkSpringGreen, .lilyWhite)
        case .amber: colors = ButtonColors(.rowAmber, .moonYellow, .rowAmber, .oasis)
        case .red: colors = ButtonColors(.white, .persianRed, .darkRed, .vanillaIce)
        }

        return colors
    }

    private enum Dimensions {
        static let height: CGFloat = 40.0
    }

    var body: some View {
        Button(LocalizedStringKey(targetColor.rawValue)) {
            self.selectedColor = self.targetColor
        }
            .frame(height: Dimensions.height)
            .frame(maxWidth: .infinity)
            .foregroundColor(selectedColor == targetColor ? colors.activeTextColor : colors.inactiveTextColor)
            .background(selectedColor == targetColor ? colors.activeBackgroundColor: colors.inActiveBackgroundColor)
            .cornerRadius(.infinity)
    }
}

struct TrafficLightButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TrafficLightButton(targetColor: .green,
                               selectedColor: .constant(.green))
            Divider()
            TrafficLightButton(targetColor: .green,
                               selectedColor: .constant(.red))
            Divider()
            TrafficLightButton(targetColor: .amber,
                               selectedColor: .constant(.amber))
            Divider()
            TrafficLightButton(targetColor: .amber,
                               selectedColor: .constant(.green))
            Divider()
            TrafficLightButton(targetColor: .red,
                               selectedColor: .constant(.red))
            TrafficLightButton(targetColor: .red,
            selectedColor: .constant(.green))
        }
    }
}
