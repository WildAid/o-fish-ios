//
//  LocationButton.swift
//
//  Created on 5/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LocationButton: View {
    var action: () -> Void
    var showingBackground = true

    private enum Dimensions {
        static let cornerRadius: CGFloat = 4.0
        static let opacity = 0.7
        static let size: CGFloat = 32.0
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                if showingBackground {
                    Rectangle()
                        .fill(Color.white.opacity(Dimensions.opacity))
                        .cornerRadius(Dimensions.cornerRadius)
                }
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
            }
        }
            .frame(width: Dimensions.size, height: Dimensions.size)
    }
}

struct LocationButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LocationButton(action: {})
                .background(Color.black)
            Divider()
            LocationButton(action: {}, showingBackground: false)
                .background(Color.black)
        }
    }
}
