//
//  TrafficLightButton.swift
//
//  Created on 05/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

private typealias ButtonColors = (activeTextColor: Color, activeBackgroundColor: Color, inactiveTextColor: Color, inActiveBackgroundColor: Color)

struct TrafficLightButton: View {

    var targetColor: SafetyLevelViewModel.LevelColor
    @Binding var selectedColor: SafetyLevelViewModel.LevelColor
    @Environment(\.colorScheme) var colorScheme

    private var colors: ButtonColors {
        var colors: ButtonColors
        if colorScheme == .dark {
            switch targetColor {
            case .green: colors = ButtonColors(.black, .lightSpringGreen, .lightSpringGreen, .clear)
            case .amber: colors = ButtonColors(.rowAmber, .moonLightYellow, .moonYellow, .clear)
            case .red: colors = ButtonColors(.black, .persianLightRed, .persianRed, .clear)
            }
        } else {
            switch targetColor {
            case .green: colors = ButtonColors(.white, .darkSpringGreen, .darkSpringGreen, .lilyWhite)
            case .amber: colors = ButtonColors(.rowAmber, .moonYellow, .rowAmber, .oasis)
            case .red: colors = ButtonColors(.white, .persianRed, .darkRed, .vanillaIce)
            }
        }

        return colors
    }

    private enum Configuration {
        static let opacityFactor: Double = 0.3
        static let height: CGFloat = 40.0
        static let radius: CGFloat = 50.0
    }

    var body: some View {
        Button(LocalizedStringKey(targetColor.rawValue.uppercased())) {
            self.selectedColor = self.targetColor
        }
        .buttonStyle(PlainButtonStyle())
        .font(self.font)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(.horizontal, Configuration.height / 4)
        .frame(height: Configuration.height)
        .frame(maxWidth: .infinity)
        .foregroundColor(self.foregroundColor)
        .background(self.backgroundColor)
        .cornerRadius(Configuration.radius)
        .overlay(
            RoundedRectangle(cornerRadius: Configuration.radius)
                .stroke(borderColor, lineWidth: 1)
        )
    }

    private var currentlySelected: Bool {
        selectedColor == targetColor
    }

    private var foregroundColor: Color {
        currentlySelected ? colors.activeTextColor : colors.inactiveTextColor
    }

    private var backgroundColor: Color {
        currentlySelected ? colors.activeBackgroundColor : colors.inActiveBackgroundColor.opacity(Configuration.opacityFactor)
    }

    private var borderColor: Color {
        !currentlySelected && colorScheme == .dark ? foregroundColor : .clear
    }

    private var font: Font {
        currentlySelected ? Font.callout.weight(.semibold) : Font.callout
    }

}

struct TrafficLightButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                TrafficLightButton(targetColor: .green, selectedColor: .constant(.green))
                Divider()
                TrafficLightButton(targetColor: .green, selectedColor: .constant(.red))
                Divider()
                TrafficLightButton(targetColor: .amber, selectedColor: .constant(.amber))
            }
            .environment(\.locale, .init(identifier: "uk"))
            HStack {
                TrafficLightButton(targetColor: .amber, selectedColor: .constant(.green))
                Divider()
                TrafficLightButton(targetColor: .red, selectedColor: .constant(.red))
                Divider()
                TrafficLightButton(targetColor: .red, selectedColor: .constant(.green))
            }
            .environment(\.colorScheme, .dark)
        }
        .previewLayout(.fixed(width: 400.0, height: 200.0))
    }
}
