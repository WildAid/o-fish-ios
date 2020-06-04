//
//  PhotoIDsDisplayView.swift
//
//  Created on 24/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import RealmSwift

class PhotoList: ObservableObject {
    @Published var photos: [PhotoViewModel] = []
}

struct PhotoIDsDisplayView: View {

    var photoIDs: [String]
    var deletePhoto: ((PhotoViewModel) -> Void)?

    @ObservedObject var photoList = PhotoList()

    init(photoIDs: [String], deletePhoto: ((PhotoViewModel) -> Void)? = nil) {
        self.photoIDs = photoIDs
        self.deletePhoto = deletePhoto
        for id in photoIDs {
            do {
                let _id = try ObjectId(string: id)
                let predicate = NSPredicate(format: "_id == %@", _id)
                let realmPhotos = RealmConnection.realm?.objects(Photo.self).filter(predicate)
                if let realmPhotos = realmPhotos {
                    if let photo = realmPhotos.first {
                        photoList.photos.append(PhotoViewModel(photo: photo))
                    }
                }
            } catch {
                print("Unable to convert the photo's id to an ObjectID: \(error)")
            }
        }
    }

    var body: some View {
        PhotosDisplayView(photos: self.photoList.photos, deletePhoto: self.deletePhoto)
    }
}

struct PhotoIDsDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        func dummy(_: PhotoViewModel) { }
        return Group {
            // Use ID's of Photo Objects that are stored in your Realm
            PhotoIDsDisplayView(photoIDs: ["45A7312B-3DA9-4FFD-A20A-DE5DE8306CF7", "2BBA0ECB-339C-4C90-B570-DC344168C305"], deletePhoto: dummy)
            PhotoIDsDisplayView(photoIDs: ["45A7312B-3DA9-4FFD-A20A-DE5DE8306CF7", "2BBA0ECB-339C-4C90-B570-DC344168C305"])
        }
    }
}
