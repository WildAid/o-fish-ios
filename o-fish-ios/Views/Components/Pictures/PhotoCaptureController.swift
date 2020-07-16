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

    private let maximumImageSize = Constants.maximumImageSize

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }

    static func show(reportID: String,
                     source: UIImagePickerController.SourceType,
                     photoTaken: ((PhotoCaptureController, String) -> Void)? = nil) {

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

    private func compressImageIfNeeded(image: UIImage) -> UIImage? {
        let resultImage = image

        if let data = resultImage.jpegData(compressionQuality: 1) {
            if data.count > maximumImageSize {

                let neededQuality = CGFloat(maximumImageSize) / CGFloat(data.count)
                if let resized = resultImage.jpegData(compressionQuality: neededQuality),
                   let resultImage = UIImage(data: resized) {

                    return resultImage
                } else {
                    print("Fail to resize image")
                }
            }
        }
        return resultImage
    }
}

extension PhotoCaptureController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let editedImage = info[.editedImage] as? UIImage,
              let result = compressImageIfNeeded(image: editedImage) else {
            print("Could't get the camera/library image")
            return
        }

        photo.date = Date()
        photo.picture = result
        photo.thumbNail = result.thumbnail(size: imageSizeThumbnails)
        savePhoto()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hide()
    }
}
