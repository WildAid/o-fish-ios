//
//  MapView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var location: CLLocationCoordinate2D
    @Binding var recenter: () -> Void
    let settings = Settings.shared

    var locationManager = CLLocationManager()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let radius = CLLocationDistance(settings.intialZoomLevel)

        if let boarderCoordinates = AreaManager.shared.readJson(fileName: "test") {
            for boarderLine in boarderCoordinates {
                let polyline = MKPolyline(coordinates: boarderLine, count: boarderLine.count)
                mapView.addOverlay(polyline)
            }
        }

        mapView.region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.location = mapView.centerCoordinate
            parent.recenter = {
                print("centerCoordinate: \(self.parent.centerCoordinate.latitude), \(self.parent.centerCoordinate.longitude)")
                mapView.setCenter(self.parent.centerCoordinate, animated: true)
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let polylineRender = MKPolylineRenderer(overlay: overlay)
                polylineRender.strokeColor = UIColor.main
                polylineRender.lineWidth = 1.0

                return polylineRender
            }

            return MKOverlayRenderer()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: .constant(LocationViewModel.sample.location),
                location: .constant(LocationViewModel.sample.location),
                recenter: .constant({}))
            .environmentObject(Settings.shared)
    }
}
