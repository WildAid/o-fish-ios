//
//  StatusSymbolView.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

private typealias StatusColors = (textColor: Color, backgroundColor: Color)

enum Size {
    case small, large
}

struct StatusSymbolView: View {
    @State var risk: SafetyLevelViewModel.LevelColor
    @Environment(\.colorScheme) var colorScheme
    var size: Size = .small

    private var colors: StatusColors {
        var colors: StatusColors
        if self.colorScheme == .dark {
            switch risk {
            case .red: colors = StatusColors(.persianLightRed, .clear)
            case .amber: colors = StatusColors(.moonLightYellow, .clear)
            case .green: colors = StatusColors(.lightSpringGreen, .clear)
            }
        } else {
            switch risk {
            case .red: colors = StatusColors(.faluRed, .vanillaIce)
            case .amber: colors = StatusColors(.rowAmber, .oasis)
            case .green: colors = StatusColors(.crusoe, .bubbles)
            }
        }
        return colors
    }

    var body: some View {
        Text(LocalizedStringKey(self.risk.rawValue))
            .textCase(.uppercase)
            .font(self.font)
            .foregroundColor(self.colors.textColor)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, self.padding)
            .frame(width: self.width, height: self.height)
            .background(
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(self.colors.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(self.colorScheme == .dark ? self.colors.textColor : Color.clear,
                            lineWidth: 1)
            )
    }

    private var padding: CGFloat {
        self.size == .small ? 6 : 12
    }

    private var height: CGFloat {
        size == .small ? 24 : 36
    }

    private var width: CGFloat {
        size == .small ? 68 : 100
    }

    private var font: Font {
        size == .small ? Font.caption1.weight(.semibold) : Font.body.weight(.semibold)
    }
}

struct StatusSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                StatusSymbolView(risk: .amber)
                Divider()
                StatusSymbolView(risk: .green)
                Divider()
                StatusSymbolView(risk: .red, size: .large)
            }
            Spacer()
            HStack {
                StatusSymbolView(risk: .amber)
                Divider()
                StatusSymbolView(risk: .green)
                Divider()
                StatusSymbolView(risk: .red, size: .large)
            }
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            Spacer()
            HStack {
                StatusSymbolView(risk: .amber)
                Divider()
                StatusSymbolView(risk: .green)
                Divider()
                StatusSymbolView(risk: .red, size: .large)
            }
            .environment(\.locale, .init(identifier: "uk"))
        }
        .previewLayout(.fixed(width: 400.0, height: 200.0))
    }
}
