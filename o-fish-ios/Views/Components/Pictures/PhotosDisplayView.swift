//
//  PhotosDisplayView.swift
//
//  Created on 24/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PhotosDisplayView: View {

    let photos: [PhotoViewModel]
    var deletePhoto: ((PhotoViewModel) -> Void)?

    var body: some View {
        VStack {
            CaptionLabel(title: "Photos:")
            PhotoThumbNailGrid(photos: self.photos, deletePhoto: self.deletePhoto)
        }
    }
}

struct PhotosDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        func dummy(_: PhotoViewModel) { }
        return PhotosDisplayView(
            photos: [.sample, .sample, .sample, .sample], deletePhoto: dummy
        )
            .environmentObject(ImageCache())
    }
}
