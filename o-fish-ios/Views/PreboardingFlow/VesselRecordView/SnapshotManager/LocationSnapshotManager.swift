//
//  LocationSnapshotManager.swift
//
//  Created on 3/26/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import MapKit

class LocationSnapshotManager {

    var picture: UIImage {
        var result: UIImage = UIImage()
        isolationQueue.sync(flags: .barrier) {
            result = internalPicture
        }
        return result
    }

    private let isolationQueue = DispatchQueue(label: "isolationQueue.SnapshotManager",
                                               attributes: .concurrent)

    private var internalPicture: UIImage = UIImage()

    let settings = Settings.shared

    private enum Factors {
        static let pinScale: CGFloat = 0.5
        static let pinWidthMultiplier: CGFloat = 0.25
    }

    func createImageFrom(_ location: CLLocationCoordinate2D, in size: CGFloat, execute: @escaping () -> Void) {
        let options = MKMapSnapshotter.Options()
        let radius = CLLocationDistance(settings.intialZoomLevel)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: radius, longitudinalMeters: radius)

        options.region = region
        options.size = CGSize(width: size, height: size)

        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else { return }

            let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                let point = snapshot.point(for: location)

                snapshot.image.draw(at: .zero)
                self.drawMKPinAnnotation(for: point)
            }
            DispatchQueue.main.async {
                self.set(image)
                execute()
            }
        }
    }

    private func set(_ image: UIImage) {
        isolationQueue.async(flags: .barrier) {
            self.internalPicture = image
        }
    }

    private func drawMKPinAnnotation(for point: CGPoint) {
        let pinView = MKPinAnnotationView()

        let pinImage = pinView.image?.resize(scale: Factors.pinScale)
        guard let width = pinImage?.size.width,
            let height = pinImage?.size.height else { return }

        var centeredPoint = CGPoint(x: point.x, y: point.y)
        centeredPoint.x -= width * Factors.pinWidthMultiplier
        centeredPoint.y -= height

        pinImage?.draw(at: centeredPoint)

    }
}
