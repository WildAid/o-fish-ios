//
//  VesselIconView.swift
//
//  Created on 4/17/20.
//

import SwiftUI

struct VesselIconView: View {

    var imageSize: CGFloat = 64
    var cornerRadius: CGFloat = 6.0

    var body: some View {
        Image("vesselIconItem")
            .resizable()
            .frame(width: imageSize,
                height: imageSize,
                alignment: .center)
            .foregroundColor(.white)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(cornerRadius)
    }
}

struct VesselIconView_Previews: PreviewProvider {
    static var previews: some View {
        VesselIconView()
    }
}
