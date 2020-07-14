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
                return imageView(for: image)
            } else {
                return AnyView(VesselIconView(imageSize: imageSize))
            }
        }
            .cornerRadius(cornerRadius)
    }

    private func imageView(for photo: PhotoViewModel) -> AnyView {
        AnyView(
            Group {
                if photo.thumbNail != nil || photo.picture != nil {
                    Image(uiImage: photo.thumbNail ?? photo.picture ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
                } else if photo.pictureURL != "" {
                    RemoteImageView(
                        imageURL: photo.pictureURL,
                        height: imageSize,
                        width: imageSize)
                }
            }
        )
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
