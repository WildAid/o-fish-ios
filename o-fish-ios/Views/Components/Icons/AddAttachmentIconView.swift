//
//  AddAttachmentIconView.swift
//
//  Created on 4/14/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AddAttachmentIconView: View {
    private enum Dimensions {
        static let padding: CGFloat = 5.0
        static let imageSize: CGFloat = 20.0
    }

    var body: some View {
        Image(systemName: "paperclip")
            .font(.system(size: Dimensions.imageSize))
            .foregroundColor(Color.lightGrayIcon)
            .padding(.top, Dimensions.padding)
    }
}

struct AddAttachmentIconView_Previews: PreviewProvider {
    static var previews: some View {
        AddAttachmentIconView()
    }
}
