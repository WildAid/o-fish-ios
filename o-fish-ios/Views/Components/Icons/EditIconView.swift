//
//  EditIconView.swift
//
//  Created on 4/14/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct EditIconView: View {

    var topPadding: CGFloat = 5.0
    var imageSize: CGFloat = 20.0

    var body: some View {
        Image(systemName: "pencil")
            .font(.system(size: imageSize))
            .foregroundColor(Color.lightGrayIcon)
            .padding(.top, topPadding)
    }
}

struct EditIconView_Previews: PreviewProvider {
    static var previews: some View {
        EditIconView()
    }
}
