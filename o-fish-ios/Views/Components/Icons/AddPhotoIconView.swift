//
//  AddPhotoIconView.swift
//
//  Created on 15/04/2020.
//
import SwiftUI

struct AddPhotoIconView: View {
    private enum Dimensions {
        static let padding: CGFloat = 10
        static let imageSize: CGFloat = 25.0
    }

    var body: some View {
        Image(systemName: "camera.fill")
            .font(.system(size: Dimensions.imageSize))
            .foregroundColor(.iconsGray)
            .padding(.top, Dimensions.padding)
    }
}

struct AddPhotoIconView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoIconView()
    }
}
