//
//  ImagePicker.swift
//
//  Created on 02/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PhotoTaker: UIViewControllerRepresentable {

    @Binding var isShown: Bool
    @Binding var photo: PhotoViewModel
    let photoTaken: () -> Void

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoTaker>) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, photo: $photo, photoTaken: photoTaken)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoTaker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator

        // Prevents a crash when running in a simulator as the camera is
        // not available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            print("No camera found - using photo library instead")
            picker.sourceType = .photoLibrary
        }
        picker.allowsEditing = true

        return picker
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var isShown: Bool
        @Binding var photo: PhotoViewModel
        let photoTaken: () -> Void

        init(isShown: Binding<Bool>, photo: Binding<PhotoViewModel>, photoTaken: @escaping () -> Void) {
            _isShown = isShown
            _photo = photo
            self.photoTaken = photoTaken
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let uiImage = info[.editedImage] as? UIImage else {
                print("Could't get the camera/library image")
                return
            }

            photo.date = Date()
            photo.picture = uiImage
            isShown = false
            photoTaken()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
}

struct PhotoTaker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoTaker(
            isShown: .constant(true),
            photo: .constant(PhotoViewModel(photo: Photo())), photoTaken: { })
    }
}
