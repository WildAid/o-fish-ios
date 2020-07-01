//
//  AddAttachmentsModalView.swift
//  
//  Created on 6/26/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AddAttachmentsModalView: View {

    var photo: () -> Void
    var note: () -> Void
    var cancel: () -> Void

    private enum Dimensions {
        static let padding: CGFloat = 8.0
        static let radius: CGFloat = 15.0
        static let bottomPadding: CGFloat = 60.0
    }

    var body: some View {
        VStack(spacing: Dimensions.padding) {
            Spacer()
            VStack(spacing: .zero) {
                ActionSheetButton(title: "Photo", radius: 0, action: photo)
                Divider()
                ActionSheetButton(title: "Note", radius: 0, action: note)
            }
                .background(Color.white)
                .cornerRadius(Dimensions.radius)
                .padding(.horizontal, Dimensions.padding)

            ActionSheetButton(title: "Cancel", action: cancel)
                .font(Font.title3.weight(.semibold))
        }
            .edgesIgnoringSafeArea(.all)
    }
}

struct AddAttachmentsModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddAttachmentsModalView(photo: {}, note: {}, cancel: {})
            .background(Color.black)
    }
}
