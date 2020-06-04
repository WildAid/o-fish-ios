//
//  PhotoFullSizeView.swift
//
//  Created on 24/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PhotoFullSizeView: View {

    @ObservedObject var photo: PhotoViewModel

    @EnvironmentObject var imageCache: ImageCache
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if photo.picture != nil {
                Image(uiImage: photo.picture!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if photo.pictureURL != "" {
                AsyncImage(
                    urlString: photo.pictureURL,
                    cache: self.imageCache
                )
            }
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                BackButton(label: "Dismiss")
            })
    }
}

struct PhotoFullSizeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhotoFullSizeView(photo: .sample)
                .environmentObject(ImageCache())
        }
    }
}
