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
        guard let reports = app.currentUser?.agencyRealm()?.objects(Report.self)
                .filter(predicate)
                .sorted(byKeyPath: "timestamp", ascending: false) else {
            return []
        }

        guard let photos = reports.filter({ report in
            return report.vessel?.attachments?.photoIDs.count ?? 0 > 0
        }).first?.vessel?.attachments?.photoIDs else { return [] }

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
        guard let photos = app.currentUser?.agencyRealm()?.objects(Photo.self).filter(predicate) else {
            return []
        }

        return photos.map { PhotoViewModel(photo: $0) }
    }

    func lastVesselImage(permitNumber: String) -> PhotoViewModel? {
        let photoIds = self.lastVesselImagesId(permitNumber: permitNumber)
        let limit = 1
        let limitedPhotoIds = Array(photoIds.prefix(limit))
        let photos = self.photoViewModels(imagesId: limitedPhotoIds)
        return photos.first
    }
}
