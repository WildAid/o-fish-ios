//
//  PatrolBoatUserView.swift
//
//  Created on 22/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PatrolBoatUserView: View {
    var photo: PhotoViewModel?
    @Binding var onSea: Bool
    var size: Size = .small
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            ZStack {
                image
                    .cornerRadius(.infinity)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        OnOffCircleView(onSea: $onSea, size: size)
                    }
                }
            }
        }
            .frame(width: buttonSize, height: buttonSize)
    }

    private var imageSize: CGFloat {
        size == .small ? 30.0 : 52.0
    }

    private var buttonSize: CGFloat {
        size == .small ? 36.0 : 62.0
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
        Group {
            PatrolBoatUserView(onSea: .constant(true), size: .small)
            PatrolBoatUserView(onSea: .constant(false), size: .large)
        }
    }
}
