//
//  ActionSheetButton.swift
//  
//  Created on 7/1/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ActionSheetButton: View {
    var title = ""
    var color = Color.blue
    var radius: CGFloat = 15.0
    var action: () -> Void

    private enum Dimensions {
        static let padding: CGFloat = 8.0
        static let buttonPadding: CGFloat = 21.0
    }

    var body: some View {
        Button(action: action) {
            Spacer()
            Text(title)
                .foregroundColor(color)
                .padding(Dimensions.buttonPadding)
            Spacer()
        }
            .background(Color.white)
            .cornerRadius(radius)
            .padding(.horizontal, Dimensions.padding)
            .font(.title3)

    }
}

struct ActionSheetButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetButton(title: "Test", action: {})
            .background(Color.red)
    }
}
