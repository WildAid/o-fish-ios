//
//  ColoredToggleStyle.swift
//
//  Created on 3/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ColoredToggleStyle: ToggleStyle {

    private enum Dimensions {
        static let rectangleWidth: CGFloat = 80
        static let rectangleHeight: CGFloat = 25
        static let rectangleCornerRadius: CGFloat = 16
        static let textInsideFont: CGFloat = 8
        static let textInsideOffset: CGFloat = 10
        static let thumbOffset: CGFloat = 25
        static let thumbPadding: CGFloat = 1.5
        static let radius: CGFloat = 1.0
        static let duration = 0.2

    }

    let label: String
    let onInsideLabel: String
    let offInsideLabel: String

    var onColor = Color.green
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Button(action: { configuration.isOn.toggle() }) {
                RoundedRectangle(cornerRadius: Dimensions.rectangleCornerRadius, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: Dimensions.rectangleWidth, height: Dimensions.rectangleHeight)
                    .overlay(
                        Text(configuration.isOn ? LocalizedStringKey(onInsideLabel) : LocalizedStringKey(offInsideLabel))
                            .font(.system(size: Dimensions.textInsideFont))
                            .bold()
                            .foregroundColor(configuration.isOn ? .white : .black)
                            .offset(x: configuration.isOn ? -Dimensions.textInsideOffset : Dimensions.textInsideOffset))
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: Dimensions.radius, x: 0, y: 1)
                            .padding(Dimensions.thumbPadding)
                            .offset(x: configuration.isOn ? Dimensions.thumbOffset : -Dimensions.thumbOffset))
                    .animation(Animation.easeInOut(duration: Dimensions.duration))
            }
        }
            .font(.title)
    }
}
