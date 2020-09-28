//
//  MapDisplayView.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import MapKit

struct MapDisplayView: UIViewRepresentable {
    var location: LocationViewModel
    let settings = Settings.shared

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let radius = CLLocationDistance(settings.intialZoomLevel)
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        mapView.region = MKCoordinateRegion(center: location.location, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapDisplayView

        init(_ parent: MapDisplayView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            var region = mapView.region
            region.center = CLLocationCoordinate2D(latitude: parent.location.location.latitude, longitude: parent.location.location.longitude)
            mapView.region = region
        }
    }
}

struct MapDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        MapDisplayView(location: .sample)
            .environmentObject(Settings.shared)
    }
}
