//
//  PhotoVesselView.swift
//  
//  Created on 7/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PhotoVesselView: View {
    @EnvironmentObject var imageCache: ImageCache
    var photo: PhotoViewModel
    var body: some View {
        VesselAsyncImage(
            photo: photo,
            cache: imageCache)
    }
}

struct PhotoVesselView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoVesselView(photo: .sample)
            .environmentObject(ImageCache())
    }
}
