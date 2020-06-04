//
//  PhotoCaptureView.swift
//
//  Created on 02/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PhotoCaptureView: View {

    @Binding var showingPhotoTaker: Bool
    @Binding var photoID: String
    let reportID: String
    let photoTaken: () -> Void

    @State private var photo = PhotoViewModel()

    var body: some View {
        return PhotoTaker(isShown: $showingPhotoTaker, photo: self.$photo, photoTaken: savePhoto)
    }

    func savePhoto() {
        photoID = photo.id
        photo.referencingReportID = reportID
        photo.save()
        photoTaken()
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(
            showingPhotoTaker: .constant(true),
            photoID: .constant("12345"),
            reportID: "12345",
            photoTaken: { }
        )
    }
}
