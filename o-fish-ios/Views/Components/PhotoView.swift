//
//  PhotoView.swift
//
//  Created on 22/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PhotoView: View {
    var photo: PhotoViewModel

    var imageSize: CGFloat = 64
    var contentMode: ContentMode = .fill

    var body: some View {
        Group {
            if photo.thumbNail != nil || photo.picture != nil {
                Image(uiImage: photo.thumbNail ?? photo.picture ?? UIImage())
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: imageSize, height: imageSize)
            } else if photo.pictureURL != "" {
                RemoteImageView(
                    imageURL: photo.pictureURL,
                    height: imageSize,
                    width: imageSize)
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: .sample)
    }
}
