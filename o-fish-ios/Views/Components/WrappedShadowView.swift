//
//  WrappedShadowView.swift
//
//  Created on 03/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

func wrappedShadowView<Content: View>
    (@ViewBuilder view: () -> Content) -> some View {

    let horizontalPadding: CGFloat = 16.0

    return
        view()
            .padding(.horizontal, horizontalPadding)
            .background(Color.white)
            .compositingGroup()
            .defaultShadow()
}

struct WrappedShadowView_Previews: PreviewProvider {
    static var previews: some View {
        wrappedShadowView {
            Text("Shadow...")
        }
    }
}
