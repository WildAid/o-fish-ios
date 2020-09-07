//
//  PatrolBoatUserView.swift
//
//  Created on 22/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PatrolBoatUserView: View {
    var name: String
    var photo: PhotoViewModel?

    var action: () -> Void = {}

    var padding: CGFloat = 8
    private let imageSize: CGFloat = 32.0

    var body: some View {
        Button(action: action) {
            HStack(spacing: padding) {
                image
                    .cornerRadius(.infinity)
                    .padding(.trailing, padding)

                Text(name)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .font(.body)
            }
        }
    }

    var image: some View {
        Group<AnyView> {
            if let image = photo {
                return AnyView(PhotoView(photo: image, imageSize: imageSize))
            } else {
                return AnyView(PersonIconView().frame(width: imageSize, height: imageSize))
            }
        }
    }
}

struct PatrolBoatUserView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PatrolBoatUserView(name: "First Second")
        }
    }
}
