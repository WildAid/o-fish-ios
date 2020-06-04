//
//  GlassIconView.swift
//
//  Created on 4/17/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct GlassIconView: View {
    private let sizeImage: CGFloat = 24.0
    var body: some View {
        Image(systemName: "magnifyingglass")
            .frame(width: sizeImage, height: sizeImage)
    }
}

struct GlassIconView_Previews: PreviewProvider {
    static var previews: some View {
        GlassIconView()
    }
}
