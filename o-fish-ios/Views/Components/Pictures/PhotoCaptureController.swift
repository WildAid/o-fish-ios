//
//  PhotoCaptureController.swift
//
//  Created on 17/06/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit

class PhotoCaptureController: UIImagePickerController {

    private var photoTaken: ((PhotoCaptureController, String) -> Void)?
    private var reportID: String = ""

    var photo = PhotoViewModel()
    private let imageSizeThumbnails: CGFloat = 102

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }

    static func show(reportID: String, photoTaken: ((PhotoCaptureController, String) -> Void)? = nil) {
        let picker = PhotoCaptureController()
        picker.setup()
        picker.reportID = reportID
        picker.photoTaken = photoTaken
        picker.present()
    }

    func setup() {
        if PhotoCaptureController.isSourceTypeAvailable(.camera) {
            sourceType = .camera
        } else {
            print("No camera found - using photo library instead")
            sourceType = .photoLibrary
        }

        allowsEditing = true

        delegate = self
    }

    func present() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true)
    }

    func hide() {
        photoTaken = nil // this preventing memory leak
        dismiss(animated: true)
    }

    private func savePhoto() {
        photo.referencingReportID = reportID
        photo.save()
        photoTaken?(self, photo.id)
    }
}

extension PhotoCaptureController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let uiImage = info[.editedImage] as? UIImage else {
            print("Could't get the camera/library image")
            return
        }

        photo.date = Date()
        photo.picture = uiImage
        photo.thumbNail = uiImage.thumbnail(size: imageSizeThumbnails)
        savePhoto()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hide()
    }
}
