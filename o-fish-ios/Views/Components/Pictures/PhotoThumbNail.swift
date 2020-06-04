//
//  PhotoThumbNail.swift
//
//  Created on 22/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PhotoThumbNail: View {

    @ObservedObject var photo: PhotoViewModel
    var imageSize: CGFloat = 102
    var deletePhoto: ((PhotoViewModel) -> Void)?
    var displayPhoto: ((PhotoViewModel) -> Void)?

    private enum Dimensions {
        static let radius: CGFloat = 4
        static let iconPadding: CGFloat = 12
    }

    var body: some View {
        ZStack {
            Button(action: { self.displayPhoto?(self.photo) }) {
                if photo.thumbNail != nil {
                    Image(uiImage: photo.thumbNail!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if photo.picture != nil {
                    Image(uiImage: photo.picture!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if photo.pictureURL != "" {
                    RemoteImageView(
                        imageURL: photo.pictureURL,
                        height: imageSize,
                        width: imageSize)
                }
            }
                .buttonStyle(PlainButtonStyle())
            if deletePhoto != nil {
                VStack(alignment: .trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { self.deletePhoto?(self.photo) }) {
                            MinusIconView()
                                .padding(Dimensions.iconPadding)
                        }
                    }
                }
            }
        }
            .frame(width: imageSize, height: imageSize)
            .background(Color.gray)
            .cornerRadius(Dimensions.radius)
    }
}

struct PhotoThumbNail_Previews: PreviewProvider {
    static var previews: some View {
        PhotoThumbNail(photo: .sample)
            .environmentObject(ImageCache())
    }
}
