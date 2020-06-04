//
//  RemoteImageView.swift
//
//  Created on 23/04/2020.
//

import SwiftUI

struct RemoteImageView: View {
    @EnvironmentObject var imageCache: ImageCache
    var imageURL: String
    var height: CGFloat
    var width: CGFloat

    var body: some View {
        AsyncImage(
            urlString: imageURL,
            cache: self.imageCache
        )
            .frame(maxWidth: width, maxHeight: height)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(imageURL: "https://image.tmdb.org/t/p/original//7GsM4mtM0worCtIVeiQt28HieeN.jpg", height: 150, width: 150)
            .environmentObject(ImageCache())
    }
}
