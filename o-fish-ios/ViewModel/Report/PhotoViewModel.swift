//
//  PhotoViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class PhotoViewModel: ObservableObject, Identifiable {
    private var photo: Photo?

    var id = ObjectId.generate().stringValue

    @Published var picture: UIImage?
    @Published var thumbNail: UIImage?
    @Published var pictureURL = ""
    @Published var date = Date()
    var thumbNailJpeg: NSData? { thumbNail?.jpegData(compressionQuality: 1.0)  as NSData? }
    var pictureJpeg: NSData? { picture?.jpegData(compressionQuality: 1.0)  as NSData? }
    var referencingReportID = ""

    convenience init(photo: Photo) {
        self.init()
        self.photo = photo
        id = photo._id.stringValue
        pictureURL = photo.pictureURL
        date = photo.date as Date
        if let thumbNail = photo.thumbNail {
            guard let uiImage = UIImage(data: thumbNail as Data) else {  return }
            self.thumbNail = uiImage
        }
        if let picture = photo.picture {
            guard let uiImage = UIImage(data: picture as Data) else { return }
            self.picture = uiImage
        }
        self.referencingReportID = photo.referencingReportID
    }

    func save() {
        let isNew = photo == nil
        do {
            guard let realm = app.currentUser()?.agencyRealm() else {
                print("Can't access Realm")
                return
            }
            try realm.write {
                if isNew {
                    photo = Photo(id: id)
                }
                guard let photo = photo else { return }
                photo.thumbNail = thumbNailJpeg
                photo.picture = pictureJpeg
                photo.pictureURL = pictureURL
                photo.date = date as NSDate
                photo.referencingReportID = referencingReportID
                if isNew {
                    realm.add(photo)
                }
            }
        } catch {
            print("Couldn't write to Realm")
            return
        }
    }

    func delete() {
        do {
            guard let realm = app.currentUser()?.agencyRealm() else {
                print("Can't access Realm to delete photo")
                return
            }
            guard let photo = photo else {
                print("No photo to delete")
                return
            }
            try realm.write {
                realm.delete(photo)
            }
        } catch {
            print("Couldn't write to Realm")
            return
        }
    }

    static func delete(photoID: String) {
        do {
            guard let realm = app.currentUser()?.agencyRealm() else {
                print("Can't access Realm to delete photo")
                return
            }
            let photo_ID = try ObjectId(string: photoID)
            let predicate = NSPredicate(format: "_id == %@", photo_ID)
            try realm.write {
                realm.delete(realm.objects(Photo.self).filter(predicate))
            }
        } catch {
            print("Couldn't write to Realm")
            return
        }
    }

    static func delete(reportID: String) {
        do {
            guard let realm = app.currentUser()?.agencyRealm() else {
                print("Can't access Realm to delete photos")
                return
            }
            let predicate = NSPredicate(format: "referencingReportID == %@", reportID)
            try realm.write {
                realm.delete(realm.objects(Photo.self).filter(predicate))
            }
        } catch {
            print("Couldn't write to Realm")
            return
        }
    }
}
