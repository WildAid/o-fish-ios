//
//  VesselImageView.swift
//
//  Created on 13/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselImageView: View {
    var vesselImage: PhotoViewModel?

    var imageSize: CGFloat = 64
    var cornerRadius: CGFloat = 6

    var body: some View {
        Group<AnyView> {
            if let image = vesselImage {
                return AnyView(PhotoView(photo: image, imageSize: imageSize))
            } else {
                return AnyView(VesselIconView(imageSize: imageSize))
            }
        }
            .cornerRadius(cornerRadius)
    }
}

struct VesselImageView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VesselImageView(vesselImage: nil)
            VesselImageView(vesselImage: .sample)
        }
    }
}
