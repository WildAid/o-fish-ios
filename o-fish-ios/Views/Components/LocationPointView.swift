//
//  LocationPointView.swift
//
//  Created on 5/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LocationPointView: View {

    private enum Dimensions {
        static let opacity = 0.1
        static let mapFrameSize: CGFloat = 34
        static let middleCircleSize: CGFloat = 14.0
        static let innerCircleSize: CGFloat = 10.0
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .opacity(Dimensions.opacity)
                .frame(width: Dimensions.mapFrameSize, height: Dimensions.mapFrameSize)
            Circle()
                .fill(Color.white)
                .frame(width: Dimensions.middleCircleSize, height: Dimensions.middleCircleSize)
            Circle()
                .fill(Color.blue)
                .frame(width: Dimensions.innerCircleSize, height: Dimensions.innerCircleSize)
        }
    }
}

struct LocationPointView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPointView()
    }
}
