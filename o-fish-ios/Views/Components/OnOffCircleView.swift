//
//  OnOffCircleView.swift
//  
//  Created on 9/8/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct OnOffCircleView: View {
    @Binding var onSea: Bool
    var size: Size

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: mapFrameSize, height: mapFrameSize)
            Circle()
                .fill(onSea ? Color.iconGreen : Color.persianRed)
                .frame(width: innerCircleSize, height: innerCircleSize)
        }
    }

    private var mapFrameSize: CGFloat {
        size == .small ? 14.0 : 25.0
    }

    private var innerCircleSize: CGFloat {
        size == .small ? 10.0 : 18.0
    }
}

struct OnOffCircleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnOffCircleView(onSea: .constant(true), size: .small)
                .background(Color.black)
            OnOffCircleView(onSea: .constant(false), size: .large)
                .background(Color.black)
        }
    }
}
