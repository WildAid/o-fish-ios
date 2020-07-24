//
//  VesselAsyncImage.swift
//  
//  Created on 7/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselAsyncImage: View {

    @ObservedObject private var loader: ImageLoader
    private var photo: PhotoViewModel

    init(photo: PhotoViewModel, cache: ImageCache) {
        self.photo = photo
        loader = ImageLoader(url: URL(string: photo.pictureURL), cache: cache)
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var image: some View {
        Image(uiImage: loader.image ?? photo.picture ?? photo.thumbNail ?? UIImage())
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct VesselAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        VesselAsyncImage(photo: .sample, cache: ImageCache())
    }
}
