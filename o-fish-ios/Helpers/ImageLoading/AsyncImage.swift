//
//  AsyncImageView.swift
//
//  Created on 23/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AsyncImage: View {
    @ObservedObject private var loader: ImageLoader

    init(urlString: String, cache: ImageCache) {
        loader = ImageLoader(url: URL(string: urlString), cache: cache)
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                LoadingIndicatorView(isAnimating: .constant(true), style: .medium)
            }
        }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(
            urlString: "https://image.tmdb.org/t/p/original//7GsM4mtM0worCtIVeiQt28HieeN.jpg",
            cache: ImageCache())
    }
}
