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
    var size: Size = .small

    private var colors: StatusColors {

        var colors: StatusColors
        switch risk {
        case .red: colors = StatusColors(.faluRed, .vanillaIce)
        case .amber: colors = StatusColors(.rowAmber, .oasis)
        case .green: colors = StatusColors(.crusoe, .bubbles)
        }

        return colors
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(colors.backgroundColor)
                .cornerRadius(.infinity)
                .frame(width: width, height: height)

            Text(NSLocalizedString(risk.rawValue, comment: "Risk color").uppercased())
                .minimumScaleFactor(0.5)
                .font(font)
                .foregroundColor(colors.textColor)
        }
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
            StatusSymbolView(risk: .amber)
            Divider()
            StatusSymbolView(risk: .green)
            Divider()
            StatusSymbolView(risk: .red, size: .large)
        }
    }
}
