//
//  EmptyDraftView.swift
//  
//  Created on 9/22/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EmptyDraftView: View {

    private enum Dimensions {
        static let spacing: CGFloat = 8.0
        static let imageSize: CGFloat = 100.0
        static let topPadding: CGFloat = 32.0
        static let circleSize: CGFloat = 150.0
        static let opacity = 0.25
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            ZStack {
                Circle()
                    .frame(width: Dimensions.circleSize, height: Dimensions.circleSize)
                    .foregroundColor(Color.main)
                    .opacity(Dimensions.opacity)
                Image(systemName: "doc.fill")
                    .frame(width: Dimensions.circleSize, height: Dimensions.circleSize)
                    .font(.system(size: Dimensions.imageSize))
                    .foregroundColor(.white)

            }

            Text("0 Draft Boardings")
                .font(.body)
        }
            .padding(.top, Dimensions.topPadding)
    }
}

struct EmptyDraftView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDraftView()
    }
}
