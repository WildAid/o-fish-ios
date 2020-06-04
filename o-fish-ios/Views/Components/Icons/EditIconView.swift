//
//  EditIconView.swift
//
//  Created on 4/14/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EditIconView: View {

    private enum Dimensions {
        static let padding: CGFloat = 5.0
        static let imageSize: CGFloat = 20.0
    }

    var body: some View {
        Image(systemName: "pencil")
            .font(.system(size: Dimensions.imageSize))
            .foregroundColor(Color.iconsGray)
            .padding(.top, Dimensions.padding)
    }
}

struct EditIconView_Previews: PreviewProvider {
    static var previews: some View {
        EditIconView()
    }
}
