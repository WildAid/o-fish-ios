//
//  MPAButton.swift
//  
//  Created on 16.05.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import SwiftUI

struct MPAButton: View {
    @Binding var mpaEnable: Bool
    @Binding var buttonEnable: Bool

    private enum Dimensions {
        static let cornerRadius: CGFloat = 4.0
        static let size: CGFloat = 32.0
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(mpaEnable ? Color.main : Color.oStrongOverlay)
                .cornerRadius(Dimensions.cornerRadius)

            Text("MPA")
                .foregroundColor(mpaEnable ? .white : .main)
                .font(.system(size: 10, weight: .bold, design: .rounded))
        }
        .frame(width: Dimensions.size, height: Dimensions.size)
        .onTapGesture {
            if buttonEnable {
                mpaEnable.toggle()
            }
        }
    }
}

struct MPAButton_Previews: PreviewProvider {
    static var previews: some View {
        MPAButton(mpaEnable: .constant(true), buttonEnable: .constant(true))
    }
}
