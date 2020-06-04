//
//  VesselIconView.swift
//
//  Created on 4/17/20.
//

import SwiftUI

struct VesselIconView: View {

    private enum Dimensions {
        static let imageSize: CGFloat = 64.0
        static let cornerRadius: CGFloat = 6.0
    }

    var body: some View {
        Image("vesselIconItem")
            .resizable()
            .frame(width: Dimensions.imageSize,
                   height: Dimensions.imageSize,
                   alignment: .center)
            .foregroundColor(.white)
            .background( Color(UIColor.systemGray5))
            .cornerRadius(Dimensions.cornerRadius)
    }
}

struct VesselIconView_Previews: PreviewProvider {
    static var previews: some View {
        VesselIconView()
    }
}
