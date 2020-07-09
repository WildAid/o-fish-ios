//
//  PhotoQueryManager.swift
//
//  Created on 08/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoQueryManager {
    static let shared = PhotoQueryManager()

    func lastVesselImagesId(permitNumber: String) -> [String] {
        let predicate = NSPredicate(format: "vessel.permitNumber = %@", permitNumber)
        let realmReports = RealmConnection.realm?.objects(Report.self)
                               .filter(predicate)
                               .sorted(byKeyPath: "timestamp", ascending: false) ?? nil

        guard let reports = realmReports else { return [] }

        let photoIds = reports
            .filter { ($0.vessel?.attachments?.photoIDs.count ?? 0) > 0}
            .first?.vessel?.attachments?.photoIDs

        guard let photos = photoIds else { return [] }
        return Array(photos)
    }

    func photoViewModels(imagesId: [String]) -> [PhotoViewModel] {
        if imagesId.isEmpty {
            return []
        }

        var indexes = [ObjectId]()
        for imageId in imagesId {
            if let index = try? ObjectId(string: imageId) {
                indexes.append(index)
            }
        }

        let predicate = NSPredicate(format: "_id IN %@", indexes)
        let realmPhotos = RealmConnection.realm?.objects(Photo.self).filter(predicate)

        guard let photos = realmPhotos else { return [] }

        var photoViewModels = [PhotoViewModel]()

        for photo in photos {
            let photo = PhotoViewModel(photo: photo)
            photoViewModels.append(photo)
        }
        return photoViewModels
    }
}
