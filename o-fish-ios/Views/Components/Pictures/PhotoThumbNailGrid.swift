//
//  PhotoThumbNailGrid.swift
//
//  Created on 24/04/2020.
//

import SwiftUI

struct PhotoThumbNailGrid: View {
    let photos: [PhotoViewModel]

    var deletePhoto: ((PhotoViewModel) -> Void)?

    @State private var photoToShow: PhotoViewModel?
    @State private var showingPhoto = false

    private enum Dimensions {
        static let imageSize: CGFloat = 102
        static let padding: CGFloat = 10
        static let noSpacing: CGFloat = 0
    }

    // TODO: See if there's a cleaner option than using `UIScreen.main.bounds.width` (at
    // time of writing, using `GeometryReader` ruins the formatting of enclosing views
    var photosPerRow: Int { Int( UIScreen.main.bounds.width / (Dimensions.imageSize + (2 * Dimensions.padding))) }
    var rows: Int { photos.count / photosPerRow + 1}

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {
            GridStack(rows: rows, columns: photosPerRow) { row, col in
                if row * self.photosPerRow + col < self.photos.count {
                    PhotoThumbNail(
                        photo: self.photos[row * self.photosPerRow + col],
                        imageSize: Dimensions.imageSize,
                        deletePhoto: self.deletePhoto,
                        displayPhoto: self.displayPhoto)
                } else {
                    EmptyView()
                }
            }
            NavigationLink(destination: PhotoFullSizeView(photo: self.photoToShow ?? .sample), isActive: self.$showingPhoto) {
                EmptyView()
            }

        }
    }

    func displayPhoto(photo: PhotoViewModel) {
        photoToShow = photo
        showingPhoto = true
    }
}

struct PhotoThumbNailGrid_Previews: PreviewProvider {
    static var previews: some View {
        func dummyFunc (_: PhotoViewModel) { }
        return Group {
            PhotoThumbNailGrid(photos: [.sample, .sample, .sample, .sample, .sample], deletePhoto: dummyFunc)
        }
            .environmentObject(ImageCache())
    }
}
